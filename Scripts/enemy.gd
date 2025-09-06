class_name Enemy extends RigidBody2D

enum MovementTypes { CONTINUOUS }
enum AnimationTypes { DOBEDOBEDOBEDO }

const dobedobedobedo_angle = 7
var physics_entity_scene : PackedScene = load("res://Scenes/physics_entity.tscn")

@export var animation_fps: float = 1.5
@export var animation_type: AnimationTypes = AnimationTypes.DOBEDOBEDOBEDO
@onready var seconds_per_frame = 1 / animation_fps
var animation_timer: float = 0.0
var animation_state: int = 0

@export var movement_force_magnitude: float = 150.0
@export var max_movement_speed: float = 75.0
@export var movement_type: MovementTypes = MovementTypes.CONTINUOUS

@export var required_impulse_to_kill: float = 22.0
@export var component_scene : PackedScene
var dead: bool = false

func enemy_move(_delta):
	if movement_type == MovementTypes.CONTINUOUS:
		var movement_direction: float = sign(GameManager.player.global_position.x - global_position.x)
		if (abs(linear_velocity.x) < max_movement_speed):
			apply_force(Vector2(movement_force_magnitude * movement_direction, 10.0))

func enemy_animate(_delta):
	if animation_type == AnimationTypes.DOBEDOBEDOBEDO:
		if abs(linear_velocity.x) < 20:
			$Sprite2D.rotation_degrees = 0
			return
		
		animation_timer += _delta
		if animation_timer > seconds_per_frame:
			animation_state *= -1
			$Sprite2D.rotation_degrees = animation_state * dobedobedobedo_angle
			animation_timer = 0

func kill():
	if dead:
		return
	dead = true
	call_deferred("become_physics_entity")

func become_physics_entity():
	var entity = physics_entity_scene.instantiate()
	entity.transform = transform
	get_tree().root.add_child(entity)
	entity.component_scene = component_scene
	
	queue_free()

func _ready():
	if animation_type == AnimationTypes.DOBEDOBEDOBEDO:
		animation_state = 1

func _process(_delta: float):
	enemy_animate(_delta)

func _physics_process(_delta):
	enemy_move(_delta)
