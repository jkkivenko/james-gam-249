extends Area2D

var signal_fired: bool = false

func _process(_delta: float) -> void:
	if signal_fired:
		return
	
	if len(get_overlapping_bodies()) && get_overlapping_bodies()[0] == GameManager.player:
		GameManager.finish_level()
		signal_fired = true
