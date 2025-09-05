class_name WeaponPivot extends RigidBody2D

## How much force the weapon rotates with.
@export var shwing_force : float = 200000
## Revs per sex
@export var max_rotation_speed : float = 2

func _process(_delta):
	var current_rps = angular_velocity / (2 * PI)
	if Input.is_action_pressed("Swing Clockwise") and current_rps < max_rotation_speed:
		apply_torque(shwing_force)
	elif Input.is_action_pressed("Swing Counterclockwise") and -current_rps < max_rotation_speed:
		apply_torque(-shwing_force)
	
