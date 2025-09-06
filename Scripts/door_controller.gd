extends Powerable

@export var move_speed: float = 100.0
## An offset (starting from its normal position) that it should move to when "opened"
@export var offset_from_closed = Vector2(-100.0, 0.0)

@onready var max_state_change_per_second = move_speed / offset_from_closed.length()
@onready var initial_position = position

# 0 indicates closed, 1 indicates open
var target_state: float = 0.0
var current_state: float = 0.0

func on_recieve_power() -> void:
	target_state = 1

func on_lose_power() -> void:
	target_state = 0

func _physics_process(delta: float):
	var state_change_this_step = min(abs(target_state - current_state), max_state_change_per_second * delta)
	current_state += state_change_this_step * sign(target_state - current_state)
	
	position = initial_position + current_state * offset_from_closed
	
