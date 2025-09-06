@tool
class_name WeaponPivot extends RigidBody2D

## How much force the weapon rotates with.
@export var shwing_force : float = 200000
## Revs per sex
@export var max_rotation_speed : float = 2
## The mass of the hilt in kgs
@export var hilt_mass : float = 0.1:
	set(new):
		hilt_mass = new
		mass = hilt_mass
## Key: a location in the tool. Value: What item is at that location
@export var components : Dictionary[Vector2i, PackedScene]:
	set(new):
		components = new
		call_deferred("instantiate_components")

func _physics_process(_delta):
	if !Engine.is_editor_hint():
		var current_rps = angular_velocity / (2 * PI)
		if Input.is_action_pressed("Swing Clockwise") and current_rps < max_rotation_speed:
			apply_torque(shwing_force)
		elif Input.is_action_pressed("Swing Counterclockwise") and -current_rps < max_rotation_speed:
			apply_torque(-shwing_force)

func instantiate_components():
	for child in get_children():
		if child is HammerComponent:
			child.queue_free()
		mass = hilt_mass
	for location in components.keys():
		var component : HammerComponent = components[location].instantiate()
		add_child(component, true)
		component.owner = self
		# Place it at the hilt position plus its position (defaulting to 1,0) times 100 pixels because
		component.position = $Hilt.position + Vector2(100 * (location + Vector2i(1,0)))
		mass += component.mass * 0.1
