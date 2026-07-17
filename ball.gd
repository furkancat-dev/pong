extends CharacterBody2D

signal ball_exited

@export var speed := 400
@onready var leftPaddle: CollisionShape2D = $"../RightPaddle/CollisionShape2D"
var direction:= Vector2(1, 0.3).normalized()

func _physics_process(delta: float) -> void:
	_check_screen_exit()
	
	var collision = move_and_collide(direction * speed * delta)
	
	if collision:
		direction = direction.bounce(collision.get_normal())

func _check_screen_exit() -> void:
	var ball_position = $CollisionShape2D.global_position.x
	var screen_width = get_viewport_rect().size.x
	
	if ball_position < 0:
		ball_exited.emit("left")
	elif ball_position > screen_width:
		ball_exited.emit("right")
