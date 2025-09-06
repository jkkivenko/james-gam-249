@tool
class_name PhysicsEntity extends RigidBody2D

@export var component_scene : PackedScene:
	set(new):
		component_scene = new
		reset_component()

var held_entity_scene : PackedScene = load("res://Scenes/held_entity.tscn")
var hovered : bool = false

func _process(_delta):
	if not Engine.is_editor_hint():
		#print("I'm a physics entity!")
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and hovered:
			create_held_entity()

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

func create_held_entity():
	var held_entity : HeldEntity = held_entity_scene.instantiate()
	add_sibling(held_entity)
	held_entity.transform = transform
	held_entity.component_scene = component_scene
	queue_free()

func _on_mouse_entered():
	hovered = true

func _on_mouse_exited():
	hovered = false
