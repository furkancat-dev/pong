extends CharacterBody2D

signal ball_exited

@export var speed := 500
@export var max_paddle_bounce_y := 1.2

var random := RandomNumberGenerator.new()
var direction := Vector2.ZERO
var has_exited_screen := false

func _ready() -> void:
	start_position()

func _physics_process(delta: float) -> void:
	_check_screen_exit()
	
	var collision = move_and_collide(direction * speed * delta)
	
	if collision:
		_handle_collision(collision)
		
func start_position() -> void:
	global_position = get_viewport_rect().size / 2
	direction = _get_random_direction()
	has_exited_screen = false
	
func _get_random_direction() -> Vector2:
	var y_direction := random.randf_range(-0.4, 0.4)
	var x_direction := -1 if random.randi_range(0, 1) == 0 else 1
	
	return Vector2(x_direction, y_direction).normalized()

func _handle_collision(collision: KinematicCollision2D) -> void:
	var collider := collision.get_collider() as Node2D

	if collider != null and collider.has_method("get_half_height"):
		_bounce_from_paddle(collider)
	else:
		direction = direction.bounce(collision.get_normal())

func _bounce_from_paddle(paddle: Node2D) -> void:
	var hit_offset: float = global_position.y - paddle.global_position.y
	var paddle_half_height: float = float(paddle.call("get_half_height"))
	var normalized_offset: float = clamp(hit_offset / paddle_half_height, -1.0, 1.0)
	var x_direction: float = 1.0 if global_position.x > paddle.global_position.x else -1.0

	direction = Vector2(x_direction, normalized_offset * max_paddle_bounce_y).normalized()

func _check_screen_exit() -> void:
	if has_exited_screen:
		return

	var ball_position = global_position.x
	var screen_width = get_viewport_rect().size.x
	
	if ball_position < 0:
		has_exited_screen = true
		ball_exited.emit("left")
	elif ball_position > screen_width:
		has_exited_screen = true
		ball_exited.emit("right")
