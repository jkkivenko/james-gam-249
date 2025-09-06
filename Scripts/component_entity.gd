@tool
class_name ComponentEntity extends RigidBody2D

@export var component_scene : PackedScene:
	set(new):
		component_scene = new
		reset_component()

var hovered : bool = false
var held : bool = false

func _process(_delta):
	if not Engine.is_editor_hint():
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if hovered:
				held = true
		else:
			held = false
	if held:
		rotation = 0
		freeze = true
		collision_mask -= 4
		var direction_to_mouse = get_viewport().get_mouse_position() - get_global_transform_with_canvas().origin
		position += direction_to_mouse
	else:
		freeze = false
		collision_mask -= 4

func reset_component():
	for child in get_children():
		if child is HammerComponent:
			child.queue_free()
	if component_scene:
		var component = component_scene.instantiate()
		if component is HammerComponent:
			add_child(component)
			component.owner = self
		else:
			push_error("Tried to attach a component that isn't a HammerComponent!")

func _on_mouse_entered():
	print("ENTER")
	hovered = true

func _on_mouse_exited():
	print("EXIT")
	hovered = false
