extends CharacterBody2D
class_name PaddleBase

enum PaddleSide {
	LEFT,
	RIGHT
}

@export var side: PaddleSide = PaddleSide.LEFT
@export var speed := 300

func _ready() -> void:
	update_position()
	# Listen viewport change
	get_viewport().size_changed.connect(update_position)

# Updates the paddle position based on the paddle type
func update_position() -> void:
	var viewport_size = get_viewport_rect().size
	var paddle_síze = $Sprite2D.texture.get_size() * $Sprite2D.scale
	
	match side:
		PaddleSide.LEFT:
			position.x = paddle_síze.x / 2
		PaddleSide.RIGHT:
			position.x = viewport_size.x - paddle_síze.x / 2

	position.y = viewport_size.y / 2
