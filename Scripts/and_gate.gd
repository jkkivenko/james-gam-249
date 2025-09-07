extends Powerable

@export var connects_to: Array[Powerable]
## The number of buttons concurrently powering this and gate required for it to activate
@export var required_power: int

var current_power: int = 0

func on_recieve_power() -> void:
	current_power += 1
	if current_power - 1 < required_power and current_power >= required_power:
		for i in connects_to:
			i.on_recieve_power()

func on_lose_power() -> void:
	current_power -= 1
	if current_power + 1 >= required_power and current_power < required_power:
		for i in connects_to:
			i.on_lose_power()
