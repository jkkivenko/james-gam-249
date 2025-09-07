class_name HammerComponent extends CollisionShape2D

@export var mass : float = 0.1
@export var is_spiky : bool = false
@export var is_springy : bool = false

func get_attachment_points() -> Array[AttachmentPoint]:
	var attachment_points : Array[AttachmentPoint] = []
	for child in get_children():
		if child is AttachmentPoint:
			attachment_points.append(child)
	return attachment_points

func _process(_delta) -> void:
	var dead_eyes = true
	if get_parent() is WeaponPivot:
		dead_eyes = false
		
	var all_googly = $Sprite2D.get_children()
	for i in all_googly:
		if i is Googly:
			i.dead = dead_eyes
		
