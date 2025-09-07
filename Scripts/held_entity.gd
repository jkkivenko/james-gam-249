@tool
class_name HeldEntity extends CharacterBody2D

## Applies a smoothing effect to the held object's position
@export_range(0,1) var smoothing : float = 0.9
# Applies a rotation effect to the held object's rotation
@export_range(0,1) var rotation_smoothing : float = 0.5

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
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and GameManager.is_holding_a_component:
			try_to_add_component()
		if Input.is_action_just_pressed("Rotate Held Object"):
			target_rotation += PI / 2.0

func try_to_add_component():
	GameManager.is_holding_a_component = false
	var did_add_component = await get_tree().get_first_node_in_group("Weapon").add_component(get_child(0))
	if did_add_component:
		queue_free()
	else:
		create_physics_entity()

func create_physics_entity():
	var physics_entity : Node2D = physics_entity_scene.instantiate()
	add_sibling(physics_entity)
	physics_entity.transform = transform
	var component = get_child(0)
	for attachment_point in component.get_attachment_points():
		attachment_point.get_node("Indicator").visible = false
	remove_child(component)
	physics_entity.add_child(component)
	physics_entity.component = component
	queue_free()
