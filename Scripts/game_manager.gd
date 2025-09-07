extends Node

var player: PlayerController

var is_holding_a_component : bool = false
var mouse_in_exclusion_zone : bool = false

var _exculsion_zone_count : int = 0

func finish_level() -> void:
	print("Level is finish :)")

func _ready() -> void:
	var drag_exculsion_zones = get_tree().get_nodes_in_group("Draggable Exclusion Collider")
	for i in drag_exculsion_zones:
		i.mouse_entered.connect(_draggable_exclusion_zone_entered)
		i.mouse_exited.connect(_draggable_exclusion_zone_exited)

#func _process(_delta: float) -> void:
	#pass

func _draggable_exclusion_zone_entered():
	_exculsion_zone_count += 1
	mouse_in_exclusion_zone = _exculsion_zone_count > 0

func _draggable_exclusion_zone_exited():
	_exculsion_zone_count -= 1
	mouse_in_exclusion_zone = _exculsion_zone_count > 0
