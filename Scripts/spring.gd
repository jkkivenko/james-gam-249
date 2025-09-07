class_name Piston extends HammerComponent

@export var springiness : float = 350
@export var cooldown : float = 1.0

@export var compressed_texture : Texture2D
@export var extended_texture : Texture2D

var time_since_last_hit : float = INF

func _process(delta):
	time_since_last_hit += delta
	#print(time_since_last_hit)
	if time_since_last_hit > cooldown:
		$Sprite2D.texture = compressed_texture
		$Sprite2D.position = Vector2.ZERO
	else:
		$Sprite2D.texture = extended_texture
		$Sprite2D.position = Vector2(0, -50)
	for body in $SpringDetectionArea.get_overlapping_bodies():
		if get_parent() is WeaponPivot and time_since_last_hit > cooldown:
			time_since_last_hit = 0.0
			get_parent().apply_impulse((-Vector2.UP).rotated(global_rotation) * springiness, global_position - get_parent().global_position)
			if body is RigidBody2D:
				body.apply_impulse(Vector2.UP.rotated(global_rotation) * springiness * 2.0)
	
