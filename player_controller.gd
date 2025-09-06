class_name PlayerController extends RigidBody2D

@export var movement_force_magnitude: float = 300.0
@export var max_movement_speed: float = 200.0
@export var bonus_friction_force_magnitude: float = 100.0

func _ready():
	GameManager.player = self

func _physics_process(_delta):
	if Input.is_action_pressed('Move Left') && linear_velocity.x > -max_movement_speed:
		apply_force(Vector2(-movement_force_magnitude, 0.0))
	elif Input.is_action_pressed('Move Right') && linear_velocity.x < max_movement_speed:
		apply_force(Vector2(movement_force_magnitude, 0.0))
	# Bonus friction
	else:
		# Prevent infinite wiggle pendulum effect
		var fake_friction_magnitude: float = min(movement_force_magnitude, abs(linear_velocity.x))
		apply_force(Vector2(-1.0 * sign(linear_velocity.x) * fake_friction_magnitude, 0.0))
