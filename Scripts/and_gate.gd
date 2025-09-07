extends Powerable

@export var connects_to: Array[Powerable]
## The number of buttons concurrently powering this and gate required for it to activate
@export var required_power: int = 2
@export var unpowered_colour: Color = Color(1.0,1.0,1.0,0.3)
@export var powered_colour: Color = Color(1.0,1.0,1.0,1.0)

var current_power: int = 0

func _ready() -> void:
	if "modulate" in self:
		modulate = unpowered_colour

func on_recieve_power() -> void:
	current_power += 1
	if current_power - 1 < required_power and current_power >= required_power:
		if "modulate" in self:
			modulate = powered_colour
		for i in connects_to:
			i.on_recieve_power()

func on_lose_power() -> void:
	current_power -= 1
	if current_power + 1 >= required_power and current_power < required_power:
		if "modulate" in self:
			modulate = unpowered_colour
		for i in connects_to:
			i.on_lose_power()
