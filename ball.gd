extends CharacterBody2D

signal ball_exited

@export var speed := 400
@onready var leftPaddle: CollisionShape2D = $"../RightPaddle/CollisionShape2D"

var random := RandomNumberGenerator.new()
var direction := Vector2.ZERO

func _ready() -> void:
	start_position()

func _physics_process(delta: float) -> void:
	_check_screen_exit()
	
	var collision = move_and_collide(direction * speed * delta)
	
	if collision:
		direction = direction.bounce(collision.get_normal())

func _check_screen_exit() -> void:
	var ball_position = global_position.x
	var screen_width = get_viewport_rect().size.x
	
	if ball_position < 0:
		ball_exited.emit("left")
	elif ball_position > screen_width:
		ball_exited.emit("right")
		
func start_position() -> void:
	global_position = get_viewport_rect().size / 2
	direction = _get_random_direction()

func _get_random_direction() -> Vector2:
	var y_direction := random.randf_range(-0.4, 0.4)
	var x_direction := -1 if random.randi_range(0, 1) == 0 else 1
	
	return Vector2(x_direction, y_direction).normalized()
