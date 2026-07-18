extends CharacterBody2D
class_name PaddleBase

enum PaddleSide {
	LEFT,
	RIGHT
}

@export var side: PaddleSide = PaddleSide.LEFT
@export var speed := 300
@onready var paddle_sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	start_position()
	get_viewport().size_changed.connect(_update_position)

func start_position() -> void:
	velocity = Vector2.ZERO
	_update_position()

func _update_position() -> void:
	var viewport_size := get_viewport_rect().size
	var paddle_size: Vector2 = paddle_sprite.texture.get_size() * paddle_sprite.scale
	
	match side:
		PaddleSide.LEFT:
			position.x = paddle_size.x / 2
		PaddleSide.RIGHT:
			position.x = viewport_size.x - paddle_size.x / 2

	position.y = viewport_size.y / 2
