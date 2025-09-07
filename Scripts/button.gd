@tool
extends Area2D

enum ButtonType { PRESS, HOLD }

@export var button_type: ButtonType = ButtonType.PRESS:
	set(new):
		button_type = new
		if button_type == ButtonType.PRESS:
			texture = press_button_texture
			pressed_texture = press_button_texture_pressed
		else:
			texture = hold_button_texture
			pressed_texture = hold_button_texture_pressed
		$Sprite2D.texture = texture
@export var connects_to: Array[Powerable]

var press_button_texture : Texture2D = preload("res://art/redtogglebutton.png") if collision_mask & 4 else preload("res://art/bluetogglebutton.png") 
var press_button_texture_pressed : Texture2D = preload("res://art/redtogglebuttonpressed.png") if collision_mask & 4 else preload("res://art/bluetogglebuttonpressed.png") 
var hold_button_texture : Texture2D = preload("res://art/redholdbutton.png") if collision_mask & 4 else preload("res://art/blueholdbutton.png") 
var hold_button_texture_pressed : Texture2D = preload("res://art/redholdbuttonpressed.png") if collision_mask & 4 else preload("res://art/blueholdbuttonpressed.png") 

var texture : Texture2D
var pressed_texture : Texture2D

var pressed: bool = false
var was_pressed: bool = false

func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		if button_type == ButtonType.PRESS:
			if has_overlapping_bodies():
				for i in connects_to:
					i.on_recieve_power()
				pressed = true
				$Sprite2D.texture = pressed_texture
		elif button_type == ButtonType.HOLD:
			pressed = has_overlapping_bodies()
			if pressed:
				$Sprite2D.texture = pressed_texture
			else:
				$Sprite2D.texture = texture
			if !was_pressed && pressed:
				for i in connects_to:
					i.on_recieve_power()
			elif was_pressed && !pressed:
				for i in connects_to:
					i.on_lose_power()
		was_pressed = pressed
