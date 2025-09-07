extends Node2D

@export var delay: float = 1.5
@export var enemy_to_summon: PackedScene
@export var max_enemies_to_summon: int = 3

var summoned_enemy
var can_summon = false
var enemies_summoned = 0
@onready var timer = delay

func _process(delta: float) -> void:
	timer -= delta
	if not summoned_enemy and not can_summon:
		can_summon = true
		timer = delay
	if can_summon and timer < 0:
		summon_enemy()
		can_summon = false

func summon_enemy():
	summoned_enemy = enemy_to_summon.instantiate()
	summoned_enemy.global_position = global_position
	get_tree().root.add_child.call_deferred(summoned_enemy)
	enemies_summoned += 1
	if enemies_summoned >= max_enemies_to_summon:
		queue_free()
