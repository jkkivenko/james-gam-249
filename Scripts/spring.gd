class_name Spring extends HammerComponent

@export var springiness : float = 350
@export var cooldown : float = 1.0

var time_since_last_hit : float = INF

func _process(delta):
	time_since_last_hit += delta
	#print(time_since_last_hit)
