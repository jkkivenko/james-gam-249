extends Powerable

@export var unpowered_colour: Color = Color(1.0,1.0,1.0,0.3)
@export var powered_colour: Color = Color(1.0,1.0,1.0,1.0)

func _ready() -> void:
	if "modulate" in self:
		modulate = unpowered_colour

func on_recieve_power() -> void:
	if "modulate" in self:
		modulate = powered_colour

func on_lose_power() -> void:
	if "modulate" in self:
		modulate = unpowered_colour
