@tool
class_name PhysicsEntity extends RigidBody2D

@export var component_scene : PackedScene:
	set(new):
		component_scene = new
		reset_component()

var component : HammerComponent
var held_entity_scene : PackedScene = load("res://Scenes/held_entity.tscn")
var hovered : bool = false

func _process(_delta):
	if not Engine.is_editor_hint():
		#print("I'm a physics entity!")
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and hovered and not GameManager.is_holding_a_component:
			create_held_entity()
			GameManager.is_holding_a_component = true

func reset_component():
	if component:
		component.queue_free()
	if component_scene:
		component = component_scene.instantiate()
		if component is HammerComponent:
			add_child(component)
			component.owner = self
		else:
			push_error("Tried to attach a component that isn't a HammerComponent!")

func create_held_entity():
	var held_entity : HeldEntity = held_entity_scene.instantiate()
	add_sibling(held_entity)
	held_entity.transform = transform
	held_entity.target_rotation = (PI / 2.0) * roundf(rotation / (PI / 2.0))
	remove_child(component)
	held_entity.add_child(component)
	queue_free()

func _on_mouse_entered():
	hovered = true

func _on_mouse_exited():
	hovered = false
