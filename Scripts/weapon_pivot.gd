class_name WeaponPivot extends RigidBody2D

## How much force the weapon rotates with.
@export var shwing_force : float = 200000
## Revs per sex
@export var max_rotation_speed : float = 2
## The maximum distance in pixels that a component will be able to connect to the hammer from.
@export var attachment_distance_threshold : float = 50.0
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
		component.get_parent().remove_child(component)
		add_child(component)
		component.rotation = -closest_attachment_point_other.rotation + closest_attachment_point_self.rotation + PI + closest_attachment_point_self.get_parent().rotation
		#print("Calculated a rotation of ", -(closest_attachment_point_self.rotation + closest_attachment_point_other.rotation))
		var position_offset = (-closest_attachment_point_other.position).rotated(component.global_rotation)
		#print("Offset by ", position_offset)
		component.global_position = closest_attachment_point_self.global_position + position_offset
		return true
	return false

#func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	#print(body.shape_owner_get_owner(body.shape_find_owner(body_shape_index)))
	#print(shape_owner_get_owner(self.shape_find_owner(local_shape_index)))
