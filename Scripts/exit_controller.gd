extends Area2D

@export var knockback_force: float = 200.0
@export var hit_cooldown: float = 0.2
@export var hits_required: int = 3
## How far the nail sticks out from the wall once fully driven
@export var final_offset: float = 30.0

@onready var offset_per_hit: float = (100.0 - final_offset) / hits_required
var hit_timer: float = 0
var times_hit: int = 0
var signal_fired: bool = false

func _process(delta: float) -> void:
	hit_timer -= delta

func _on_body_entered(body: Node2D) -> void:
	if not "collision_layer" in body:
		return
	
	if signal_fired:
		return
	
	if body.collision_layer & collision_mask != 0 and hit_timer < 0:
		global_position -= Vector2(offset_per_hit, 0.0).rotated(global_rotation)
		$AnimatableBody2D.global_position -= Vector2(offset_per_hit, 0.0).rotated(global_rotation)
		
		hit_timer = hit_cooldown
		times_hit += 1
		
		if times_hit >= hits_required:
			signal_fired = true
			GameManager.finish_level()
		
		var hit = body.get_parent()
		if hit is RigidBody2D:
			hit.apply_impulse(Vector2.RIGHT.rotated(global_rotation) * knockback_force * 2.0)
