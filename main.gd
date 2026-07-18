extends Node2D

@onready var ball_node := $Ball
@onready var left_paddle_node := $LeftPaddle
@onready var right_paddle_node := $RightPaddle
@onready var game_over_panel_node := $CanvasLayer/UI/CenterContainer/GameOverPanel

func _ready() -> void:
	ball_node.ball_exited.connect(_on_ball_exited)
	game_over_panel_node.restart_requested.connect(_on_restart_requested)
	game_over_panel_node.exit_requested.connect(_on_exit_requested)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle_pause()
		
func _on_ball_exited(side: String) -> void:
	print('EXIT', side)
	get_tree().paused = true
	game_over_panel_node.visible = true

func _on_restart_requested() -> void:
	get_tree().paused = false
	game_over_panel_node.visible = false
	ball_node.start_position()
	left_paddle_node.start_position()
	right_paddle_node.start_position()

func _on_exit_requested() -> void:
	get_tree().quit()
	
func _toggle_pause() -> void:
	game_over_panel_node.visible = !game_over_panel_node.visible
	get_tree().paused = game_over_panel_node.visible
