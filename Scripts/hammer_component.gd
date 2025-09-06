class_name HammerComponent extends CollisionShape2D

@export var mass : float = 0.1
@export var is_spiky : bool = false

func get_attachment_points() -> Array[AttachmentPoint]:
	var attachment_points : Array[AttachmentPoint] = []
	for child in get_children():
		if child is AttachmentPoint:
			attachment_points.append(child)
	return attachment_points
