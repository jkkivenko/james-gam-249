extends Node2D

const pixel_radius: float = 50
const max_pupil_velocity = 400
@onready var pupil = $Sprite2D
@onready var child_radius = pupil.scale.x * pixel_radius # assumes uniform scale
@onready var max_dist_from_center = pixel_radius - child_radius

var pupil_velocity = Vector2(0.0, 0.0)
@onready var prev_pos = global_position

func _process(delta: float):
	#if Input.is_action_pressed("Move Left"):
		#pupil.position = Vector2(0,0)
		
	#position = get_global_mouse_position()
	
	#print(global_rotation)
	
	pupil_velocity -= global_position - prev_pos
	prev_pos = global_position
	
	pupil_velocity += (Vector2.ZERO - pupil.position) * 0.05
	
	pupil.position += pupil_velocity * delta
	
	if pupil.position.length() > max_dist_from_center:
		pupil.position = pupil.position.normalized() * max_dist_from_center
		pupil_velocity = Vector2(0.0, 0.0)
	
	if pupil_velocity.length() > max_pupil_velocity:
		pupil_velocity = pupil_velocity.normalized() * max_pupil_velocity
