extends Camera2D

@onready var bottom_left_pos: Vector2 = $BottomLeft.global_position
@onready var top_right_pos: Vector2 = $TopRight.global_position

func _ready() -> void:
	limit_left = bottom_left_pos.x
	limit_bottom = bottom_left_pos.y
	limit_left = bottom_left_pos.x
	limit_left = bottom_left_pos.x

func _process(delta: float) -> void:
	global_position = GameManager.player.global_position
