@tool
class_name ComponentEntity extends RigidBody2D

@export var component_scene : PackedScene:
	set(new):
		component_scene = new
		call_deferred("instantiate_component")

func instantiate_component():
	for child in get_children():
		if child is HammerComponent:
			child.queue_free()
	if component_scene:
		var component : HammerComponent = component_scene.instantiate()
		add_child(component)
		component.owner = self
