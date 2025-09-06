extends Area2D

enum ButtonType { PRESS, HOLD }

@export var button_type: ButtonType = ButtonType.PRESS
@export var connects_to: Array[Powerable]

var pressed: bool = false
var was_pressed: bool = false

func _physics_process(_delta: float) -> void:
	if button_type == ButtonType.PRESS:
		if has_overlapping_bodies():
			for i in connects_to:
				i.on_recieve_power()
			pressed = true
	elif button_type == ButtonType.HOLD:
		pressed = has_overlapping_bodies()
		if !was_pressed && pressed:
			for i in connects_to:
				i.on_recieve_power()
		elif was_pressed && !pressed:
			for i in connects_to:
				i.on_lose_power()
	
	was_pressed = pressed
