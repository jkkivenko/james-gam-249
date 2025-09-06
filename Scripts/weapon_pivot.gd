class_name WeaponPivot extends RigidBody2D

## How much force the weapon rotates with.
@export var shwing_force : float = 200000
## Revs per sex
@export var max_rotation_speed : float = 2
## The maximum distance in pixels that a component will be able to connect to the hammer from.
@export var attachment_distance_threshold : float = 50.0
## A multiplier applied to the impulse which happens when a disconnected part explodes away from the root
@export var explosion_force : float = 1.0
## A disconnected component explodes away from the root with a random amount of angular velocity, up to this amount.
@export var explosion_rotation : float = 1.0

var held_entity_scene : PackedScene = load("res://Scenes/held_entity.tscn")
var physics_entity_scene : PackedScene = load("res://Scenes/physics_entity.tscn")

var hovered_component : HammerComponent

func _ready():
	for component in get_all_components():
		mass += component.mass

## Recursively explores the node tree to find all nodes that are HammerComponents
func get_all_components(obj : Node2D = self) -> Array[HammerComponent]:
	var components : Array[HammerComponent] = []
	for child in obj.get_children():
		if child is HammerComponent:
			components.append(child)
			components += get_all_components(child)
	return components

func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and hovered_component and not GameManager.is_holding_a_component:
		disconnect_component(hovered_component)
		for disconnected_component in get_disconnected_components():
			print("THERE IS A DISCONNECTED COMPONENT!!!!!!!!!!!!!!!!!!!")
			disconnect_component(disconnected_component, false)

func disconnect_component(component : HammerComponent, should_create_held_object : bool = true):
	# First we create the held entity that will float around the player's mouse
	var entity : Node2D
	if should_create_held_object:
		GameManager.is_holding_a_component = true
		entity = held_entity_scene.instantiate()
	else:
		entity = physics_entity_scene.instantiate()
	get_tree().root.add_child(entity)
	entity.global_transform = component.global_transform
	if should_create_held_object:
		entity.target_rotation = (PI / 2.0) * roundf(entity.global_rotation / (PI / 2.0))
	# Make sure to disconnect all attached points
	for attachment_point in component.get_attachment_points():
		if attachment_point.attached_point:
			attachment_point.attached_point.attached_point = null
			attachment_point.attached_point = null
	# Remove the currently hovered component from the hammer
	remove_child(component)
	# And add it to the floating held entity positioned correctly.
	entity.add_child(component)
	component.position = Vector2.ZERO
	if not should_create_held_object:
		entity.component = component
		entity.apply_impulse(explosion_force * (entity.global_position - global_position))
		entity.angular_velocity = explosion_rotation * (randf() - 0.5)

func get_disconnected_components() -> Array[HammerComponent]:
	var disconnected_components : Array[HammerComponent] = []
	var attached_components = get_all_attached_components()
	for component in get_all_components():
		if component not in attached_components:
			disconnected_components.append(component)
	return disconnected_components

func get_all_attached_components(root : HammerComponent = $Hilt, visited_components : Array[HammerComponent] = []) -> Array[HammerComponent]:
	visited_components.append(root)
	for attachment_point in root.get_attachment_points():
		if attachment_point.attached_point and attachment_point.attached_point.get_parent() not in visited_components:
			visited_components += get_all_attached_components(attachment_point.attached_point.get_parent(), visited_components)
	return visited_components

func _physics_process(_delta):
	if not Engine.is_editor_hint():
		var current_rps = angular_velocity / (2 * PI)
		if Input.is_action_pressed("Swing Clockwise") and current_rps < max_rotation_speed:
			apply_torque(shwing_force)
		elif Input.is_action_pressed("Swing Counterclockwise") and -current_rps < max_rotation_speed:
			apply_torque(-shwing_force)

func add_component(component : HammerComponent) -> bool:
	var closest_attachment_point_self : AttachmentPoint
	var closest_attachment_point_other : AttachmentPoint
	var min_distance = INF
	for other_attachment_point in component.get_attachment_points():
		for self_component in get_all_components():
			for self_attachment_point in self_component.get_attachment_points():
				if not self_attachment_point.attached_point:
					if self_attachment_point.global_position.distance_to(other_attachment_point.global_position) < min_distance:
						closest_attachment_point_self = self_attachment_point
						closest_attachment_point_other = other_attachment_point
						min_distance = self_attachment_point.global_position.distance_to(other_attachment_point.global_position)
	if min_distance < attachment_distance_threshold:
		closest_attachment_point_self.attached_point = closest_attachment_point_other
		closest_attachment_point_other.attached_point = closest_attachment_point_self
		#print("Other component's " + closest_attachment_point_other.name + " connected to this component's " + closest_attachment_point_self.name)
		var old_parent = component.get_parent()
		old_parent.remove_child(component)
		var component_rotation = global_rotation - closest_attachment_point_other.rotation + closest_attachment_point_self.rotation + PI + closest_attachment_point_self.get_parent().rotation
		#print("Calculated a rotation of ", -(closest_attachment_point_self.rotation + closest_attachment_point_other.rotation))
		var position_offset = (-closest_attachment_point_other.position).rotated(component_rotation)
		#print("Offset by ", position_offset)
		var component_position = closest_attachment_point_self.global_position + position_offset
		# Create a new area2d to test if anything is currently taking up the space that the new component will take up
		var collision_test_area : Area2D = Area2D.new()
		add_child(collision_test_area)
		collision_test_area.add_child(component)
		component.global_rotation = component_rotation
		component.global_position = component_position
		component.scale = Vector2.ONE * 0.9
		await get_tree().process_frame
		await get_tree().process_frame
		var is_colliding = bool(len(collision_test_area.get_overlapping_bodies()))
		#print(is_colliding)
		collision_test_area.remove_child(component)
		collision_test_area.queue_free()
		if is_colliding:
			old_parent.add_child(component)
			component.rotation = 0
			component.position = Vector2.ZERO
			return false
		# Finally, add the component to the hammer
		# Have to recalculate these because the hammer might have moved during the await step
		# This does technically mean that the player could subvert the collision detection if they're swinging the hammer REALLY HARD
		# But like, whatever
		component_rotation = global_rotation - closest_attachment_point_other.rotation + closest_attachment_point_self.rotation + PI + closest_attachment_point_self.get_parent().rotation
		position_offset = (-closest_attachment_point_other.position).rotated(component_rotation)
		component_position = closest_attachment_point_self.global_position + position_offset
		add_child(component)
		component.global_rotation = component_rotation
		component.global_position = component_position
		component.scale = Vector2.ONE
		return true
	return false

func _on_mouse_shape_entered(shape_idx):
	#print(shape_owner_get_owner(shape_find_owner(shape_idx)).name, " entered!")
	hovered_component = shape_owner_get_owner(shape_find_owner(shape_idx))
	if hovered_component == $Hilt:
		hovered_component = null

func _on_mouse_exited():
	hovered_component = null

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	# tilemap bad
	if not "shape_find_owner" in body:
		return
	
	var hit = body.shape_owner_get_owner(body.shape_find_owner(body_shape_index)).get_parent()
	# ensure you have hit an enemy
	if not "required_impulse_to_kill" in hit:
		return
	
	var block_that_performed_hit = shape_owner_get_owner(shape_find_owner(local_shape_index))
	var radial_distance = block_that_performed_hit.position.y
	
	var impulse_delivered = abs(angular_velocity * radial_distance * mass)
	
	if impulse_delivered > hit.required_impulse_to_kill or block_that_performed_hit.is_spiky:
		hit.kill()
