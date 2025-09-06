extends Camera2D

@onready var bottom_left_pos: Vector2 = $BottomLeft.global_position
@onready var top_right_pos: Vector2 = $TopRight.global_position

func _ready() -> void:
	limit_left = round(bottom_left_pos.x)
	limit_bottom = round(bottom_left_pos.y)
	limit_right = round(top_right_pos.x)
	limit_top = round(top_right_pos.y)

func _process(delta: float) -> void:
	global_position = GameManager.player.global_position
