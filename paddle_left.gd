extends PaddleBase

@onready var ball_node: Node2D = $"../Ball"
@onready var one_player_node: TextureButton = $"../CanvasLayer/UI/CenterContainer/OptionPanel/MarginContainer/VContainer/OnePlayerButton"
@export var bot_speed := 300.0
@export var dead_zone := 15.0

func _physics_process(_delta) -> void:
	if one_player_node.button_pressed:
		var difference_y := ball_node.global_position.y - global_position.y
	
		if abs(difference_y) < dead_zone:
			velocity.y = 0
		else:
			velocity.y = clamp(difference_y * 8.0, -bot_speed, bot_speed)
	else:
		velocity.y = Input.get_axis("left_up", "left_down") * speed

	move_and_slide()
