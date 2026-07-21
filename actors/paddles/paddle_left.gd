class_name BotPaddle
extends PaddleBase

enum Difficulty {
	EASY,
	NORMAL,
	HARD,
}

@export var difficulty: Difficulty = Difficulty.NORMAL

var bot_speed := 320.0
var tracking_power := 7.0
var dead_zone := 18.0

@onready var ball_node: PongBall = $"../Ball"
@onready var one_player_node: TextureButton = $"../CanvasLayer/UI/CenterContainer/OptionPanel/MarginContainer/VContainer/OnePlayerButton"

func _ready() -> void:
	super._ready()

	_apply_difficulty()

func _physics_process(_delta) -> void:
	if one_player_node.button_pressed:
		if ball_node.direction.x < 0.0:
			_follow_ball()
		else:
			velocity.y = 0.0
	else:
		velocity.y = Input.get_axis("left_up", "left_down") * speed

	move_and_slide()

func _follow_ball() -> void:
	var difference_y := ball_node.global_position.y - global_position.y

	if abs(difference_y) < dead_zone:
		velocity.y = 0.0
	else:
		velocity.y = clamp(difference_y * tracking_power, -bot_speed, bot_speed)
		
func _apply_difficulty() -> void:
	match difficulty:
		Difficulty.EASY:
			bot_speed = 220.0
			tracking_power = 4.0
			dead_zone = 35.0

		Difficulty.NORMAL:
			bot_speed = 320.0
			tracking_power = 7.0
			dead_zone = 18.0

		Difficulty.HARD:
			bot_speed = 400.0
			tracking_power = 9.0
			dead_zone = 10.0
			
func set_difficulty(new_difficulty: Difficulty) -> void:
	difficulty = new_difficulty
	_apply_difficulty()
