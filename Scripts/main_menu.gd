extends Node2D

@export var levels = ["Level 1: Bing your bong", "Level 2: Vaulting"]
@export var level_button: PackedScene

func _ready() -> void:
	for i in levels:
		var button = level_button.instantiate()
		button.text = i
		$VBoxContainer.add_child(button)
