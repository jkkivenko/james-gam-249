class_name WeaponPivot extends RigidBody2D

## How much force the weapon rotates with.
@export var shwing_force : float = 200000
## Revs per sex
@export var max_rotation_speed : float = 2

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
	if !Engine.is_editor_hint():
		var current_rps = angular_velocity / (2 * PI)
		if Input.is_action_pressed("Swing Clockwise") and current_rps < max_rotation_speed:
			apply_torque(shwing_force)
		elif Input.is_action_pressed("Swing Counterclockwise") and -current_rps < max_rotation_speed:
			apply_torque(-shwing_force)

#func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	#print(body.shape_owner_get_owner(body.shape_find_owner(body_shape_index)))
	#print(shape_owner_get_owner(self.shape_find_owner(local_shape_index)))
