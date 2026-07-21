class_name PongBall
extends CharacterBody2D

signal ball_exited

@export var speed := 500.0
@export_range(0.0, 0.5, 0.05) var paddle_movement_influence := 0.15
@export_range(0.5, 2.0, 0.05) var paddle_bounce_curve := 1.0
@export_range(30.0, 75.0, 1.0) var max_paddle_bounce_angle := 65.0

var direction: Vector2 = Vector2.ZERO
var _random := RandomNumberGenerator.new()
var _has_exited_screen := false

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
	_has_exited_screen = false
	
func _get_random_direction() -> Vector2:
	var y_direction := _random.randf_range(-0.4, 0.4)
	var x_direction := -1 if _random.randi_range(0, 1) == 0 else 1
	
	return Vector2(x_direction, y_direction).normalized()

func _handle_collision(collision: KinematicCollision2D) -> void:
	var paddle := collision.get_collider() as PaddleBase

	if paddle != null:
		_bounce_from_paddle(paddle)
	else:
		direction = direction.bounce(collision.get_normal())

func _bounce_from_paddle(paddle: PaddleBase) -> void:
	var hit_offset := global_position.y - paddle.global_position.y
	var normalized_hit := clampf(hit_offset / paddle.get_half_height(), -1.0, 1.0)
	var curved_hit := signf(normalized_hit) * pow(absf(normalized_hit), paddle_bounce_curve)
	var movement_ratio := clampf(paddle.velocity.y / paddle.speed, -1.0, 1.0)
	var aimed_hit := clampf(
		curved_hit + movement_ratio * paddle_movement_influence,
		-1.0,
		1.0
	)
	var bounce_angle := deg_to_rad(aimed_hit * max_paddle_bounce_angle)
	var x_direction := 1.0 if paddle.side == PaddleBase.PaddleSide.LEFT else -1.0

	direction = Vector2(x_direction * cos(bounce_angle), sin(bounce_angle))

func _check_screen_exit() -> void:
	if _has_exited_screen:
		return

	var ball_position = global_position.x
	var screen_width = get_viewport_rect().size.x
	
	if ball_position < 0:
		_has_exited_screen = true
		ball_exited.emit("left")
	elif ball_position > screen_width:
		_has_exited_screen = true
		ball_exited.emit("right")
