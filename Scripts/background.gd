extends Node2D

@export var test_sprite: PackedScene

func _ready() -> void:
	var camera_size = get_viewport().get_visible_rect().size
	scale = camera_size / 3
	#create_item()

func create_item():
	var item = test_sprite.instantiate()
	item.global_position = global_position
	get_tree().root.add_child.call_deferred(item)
