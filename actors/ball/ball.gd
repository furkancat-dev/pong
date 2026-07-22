class_name PongBall
extends CharacterBody2D

signal ball_exited

const LEFT_PADDLE_HIT_COLOR := Color(0.35, 0.85, 1.0)
const RIGHT_PADDLE_HIT_COLOR := Color(1.0, 0.45, 0.75)
const PADDLE_HIT_SCALE := Vector2(0.5, 1.55)
const PADDLE_HIT_HOLD_DURATION := 0.14
const PADDLE_HIT_RECOVERY_DURATION := 0.22

@export var speed := 500.0
@export_range(0.0, 0.5, 0.05) var paddle_movement_influence := 0.15
@export_range(0.5, 2.0, 0.05) var paddle_bounce_curve := 1.0
@export_range(30.0, 75.0, 1.0) var max_paddle_bounce_angle := 65.0

@onready var hit_sound: AudioStreamPlayer = $HitSound

var direction: Vector2 = Vector2.ZERO
var _random := RandomNumberGenerator.new()
var _has_exited_screen := false
var _sprite_base_scale := Vector2.ONE
var _paddle_hit_tween: Tween

@onready var ball_sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	_sprite_base_scale = ball_sprite.scale
	start_position()

func _physics_process(delta: float) -> void:
	_check_screen_exit()
	
	var collision = move_and_collide(direction * speed * delta)
	
	if collision:
		_handle_collision(collision)
		
func start_position() -> void:
	_reset_paddle_hit_animation()
	global_position = get_viewport_rect().size / 2
	reset_physics_interpolation()
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
		hit_sound.play()
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
	_play_paddle_hit_animation(paddle.side)

func _play_paddle_hit_animation(paddle_side: PaddleBase.PaddleSide) -> void:
	_reset_paddle_hit_animation()

	ball_sprite.scale = _sprite_base_scale * PADDLE_HIT_SCALE
	var hit_color := (
		LEFT_PADDLE_HIT_COLOR
		if paddle_side == PaddleBase.PaddleSide.LEFT
		else RIGHT_PADDLE_HIT_COLOR
	)
	ball_sprite.modulate = hit_color

	_paddle_hit_tween = create_tween()
	_paddle_hit_tween.tween_interval(PADDLE_HIT_HOLD_DURATION)
	_paddle_hit_tween.tween_property(
		ball_sprite,
		"scale",
		_sprite_base_scale,
		PADDLE_HIT_RECOVERY_DURATION
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_paddle_hit_tween.parallel().tween_property(
		ball_sprite,
		"modulate",
		Color.WHITE,
		PADDLE_HIT_RECOVERY_DURATION
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _reset_paddle_hit_animation() -> void:
	if _paddle_hit_tween != null:
		_paddle_hit_tween.kill()
		_paddle_hit_tween = null

	ball_sprite.scale = _sprite_base_scale
	ball_sprite.modulate = Color.WHITE

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
