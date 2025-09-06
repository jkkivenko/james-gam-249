extends Area2D

func _process(_delta: float) -> void:
	if len(get_overlapping_bodies()) && get_overlapping_bodies()[0] == GameManager.player:
		GameManager.finish_level()
