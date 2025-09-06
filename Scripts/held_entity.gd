@tool
class_name HeldEntity extends CharacterBody2D

@export var smoothing : float = 0.9
@export var rotation_smoothing : float = 0.5

var physics_entity_scene : PackedScene = load("res://Scenes/physics_entity.tscn")
var target_rotation : float = 0.0

func _process(_delta):
	if not Engine.is_editor_hint():
		#print("I'm a held entity!")
		var direction_to_mouse = get_viewport().get_mouse_position() - get_global_transform_with_canvas().origin
		velocity += direction_to_mouse
		velocity *= smoothing
		rotation = lerp_angle(rotation, target_rotation, rotation_smoothing)
		move_and_slide()
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if get_tree().get_first_node_in_group("Weapon").add_component(get_child(0)):
				queue_free()
			else:
				create_physics_entity()
		if Input.is_action_just_pressed("Rotate Held Object"):
			target_rotation += PI / 2.0

func create_physics_entity():
	var physics_entity : Node2D = physics_entity_scene.instantiate()
	add_sibling(physics_entity)
	physics_entity.transform = transform
	var component = get_child(0)
	remove_child(component)
	physics_entity.add_child(component)
	physics_entity.component = component
	queue_free()
