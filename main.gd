extends Node2D

@onready var ball_node: CharacterBody2D = $Ball
@onready var left_paddle_node: PaddleBase = $LeftPaddle
@onready var right_paddle_node: PaddleBase = $RightPaddle
@onready var option_panel_node: PanelContainer = $CanvasLayer/UI/CenterContainer/OptionPanel
@onready var game_over_panel_node:PanelContainer = $CanvasLayer/UI/CenterContainer/GameOverPanel
@onready var countdown_node: Timer = $"Countdown"
@onready var countdown_texture_node: TextureRect = $CanvasLayer/UI/CenterContainer/CountdownTexture

var countdown_value:= 3

const COUNTDOWN_TEXTURES := {
	3: preload("res://assets/countdown_3.png"),
	2: preload("res://assets/countdown_2.png"),
	1: preload("res://assets/countdown_1.png"),
}

func _ready() -> void:
	countdown_node.timeout.connect(_on_countdown_timer_timeout)
	_countdown_start()
	ball_node.ball_exited.connect(_on_ball_exited)
	option_panel_node.resume_requested.connect(_on_resume_requested)
	option_panel_node.restart_requested.connect(_on_restart_requested)
	option_panel_node.exit_requested.connect(_on_exit_requested)
	game_over_panel_node.restart_requested.connect(_on_restart_requested)
	game_over_panel_node.exit_requested.connect(_on_exit_requested)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle_pause()
		
func _countdown_start() -> void:
	get_tree().paused = true
	
	countdown_node.stop()
	countdown_node.paused = false
	countdown_value = 3
	countdown_texture_node.visible = true
	countdown_texture_node.texture = COUNTDOWN_TEXTURES[countdown_value]
	
	countdown_node.start()
		
func _on_countdown_timer_timeout() -> void:
	countdown_value -= 1
	
	if countdown_value == 2:
		countdown_texture_node.texture = COUNTDOWN_TEXTURES[countdown_value]
	elif countdown_value == 1:
		countdown_texture_node.texture = COUNTDOWN_TEXTURES[countdown_value]
	else:
		countdown_node.stop()
		countdown_texture_node.visible = false
		get_tree().paused = false
		
func _on_ball_exited(side: String) -> void:
	# side bilgisine gore score logic ekleyecegim
	print('EXIT', side)
	get_tree().paused = true
	game_over_panel_node.visible = true
	
func _on_resume_requested() -> void:
	option_panel_node.visible = false
	get_tree().paused = false

func _on_restart_requested() -> void:
	_countdown_start()
	
	game_over_panel_node.visible = false
	option_panel_node.visible = false
	
	ball_node.start_position()
	left_paddle_node.start_position()
	right_paddle_node.start_position()

func _on_exit_requested() -> void:
	get_tree().quit()
	
func _toggle_pause() -> void:
	if game_over_panel_node.visible:
		return
		
	option_panel_node.visible = !option_panel_node.visible
	
	if !countdown_texture_node.visible:
		get_tree().paused = option_panel_node.visible
	
	if option_panel_node.visible:
		countdown_node.paused = true
	else:
		countdown_node.paused = false
