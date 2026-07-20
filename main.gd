extends Node2D

@export var win_score:= 1
@onready var ball_node: CharacterBody2D = $Ball
@onready var left_paddle_node: PaddleBase = $LeftPaddle
@onready var right_paddle_node: PaddleBase = $RightPaddle
@onready var option_panel_node: PanelContainer = $CanvasLayer/UI/CenterContainer/OptionPanel
@onready var match_result_panel_node: PanelContainer = $CanvasLayer/UI/CenterContainer/MatchResultPanel
@onready var countdown_node: Timer = $"Countdown"
@onready var countdown_texture_node: TextureRect = $CanvasLayer/UI/CenterContainer/CountdownTexture
@onready var left_score_node: Label = $CanvasLayer/UI/ScorePanel/HBoxContainer/LeftScore
@onready var right_score_node: Label = $CanvasLayer/UI/ScorePanel/HBoxContainer/RightScore
@onready var match_result_label_node: TextureRect = $CanvasLayer/UI/CenterContainer/MatchResultPanel/MarginContainer/VContainer/MatchResultLabel
@onready var match_result_panel_style: StyleBoxTexture = match_result_panel_node.get_theme_stylebox("panel").duplicate()
@onready var restart_button_node: TextureButton = $CanvasLayer/UI/CenterContainer/MatchResultPanel/MarginContainer/VContainer/RestartButton
@onready var exit_button_node: TextureButton = $CanvasLayer/UI/CenterContainer/MatchResultPanel/MarginContainer/VContainer/ExitButton

enum GameMode {
	ONE_PLAYER,
	TWO_PLAYER
}

var countdown_value:= 3
var left_score:= 0
var right_score:= 0
var winner := ""
var game_mode := GameMode.ONE_PLAYER

const COUNTDOWN_TEXTURES := {
	3: preload("res://assets/countdown_3.png"),
	2: preload("res://assets/countdown_2.png"),
	1: preload("res://assets/countdown_1.png"),
}
const TEXT_GAME_OVER := preload("res://assets/text_game_over.png")
const TEXT_PLAYER_1_WINS := preload("res://assets/text_player_1_wins.png")
const TEXT_PLAYER_2_WINS := preload("res://assets/text_player_2_wins.png")
const MATCH_RESULT_PANEL_RED := preload("res://assets/game_over_panel.png")
const MATCH_RESULT_PANEL_BLUE := preload("res://assets/match_result_panel_blue.png")
const BUTTON_RESTART_RED := preload("res://assets/button_play_again.png")
const BUTTON_RESTART_PRESSED_RED := preload("res://assets/button_pressed_play_again.png")
const BUTTON_EXIT_RED := preload("res://assets/button_exit.png")
const BUTTON_EXIT_PRESSED_RED := preload("res://assets/button_pressed_exit.png")
const BUTTON_RESTART_BLUE := preload("res://assets/button_restart_blue.png")
const BUTTON_RESTART_PRESSED_BLUE := preload("res://assets/button_pressed_restart_blue.png")
const BUTTON_EXIT_BLUE := preload("res://assets/button_exit_blue.png")
const BUTTON_EXIT_PRESSED_BLUE := preload("res://assets/button_pressed_exit_blue.png")

func _ready() -> void:
	match_result_panel_node.add_theme_stylebox_override("panel", match_result_panel_style)
	countdown_node.timeout.connect(_on_countdown_timer_timeout)
	ball_node.ball_exited.connect(_on_ball_exited)
	option_panel_node.resume_requested.connect(_on_resume_requested)
	option_panel_node.restart_requested.connect(_on_restart_requested)
	option_panel_node.exit_requested.connect(_on_exit_requested)
	option_panel_node.game_mode_changed.connect(_on_game_mode_changed)
	match_result_panel_node.restart_requested.connect(_on_restart_requested)
	match_result_panel_node.exit_requested.connect(_on_exit_requested)
	
	_countdown_start()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle_pause()
		
func _countdown_start() -> void:
	get_tree().paused = true
	
	countdown_node.stop()
	countdown_node.paused = false
	countdown_value = 3
	countdown_texture_node.texture = COUNTDOWN_TEXTURES[countdown_value]
	countdown_texture_node.visible = true
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
	if side == "left":
		right_score += 1
		right_score_node.text = str(right_score)
		winner = "right"
	else:
		left_score += 1
		left_score_node.text = str(left_score)
		winner = "left"
		
	if left_score >= win_score or right_score >= win_score:
		_show_match_result()
	else:
		_on_restart_requested()

func _show_match_result() -> void:
	get_tree().paused = true
	
	if game_mode == GameMode.ONE_PLAYER:
		match_result_label_node.texture = TEXT_GAME_OVER
		match_result_panel_style.texture = MATCH_RESULT_PANEL_RED
		_set_match_result_button_textures(
			BUTTON_RESTART_RED,
			BUTTON_RESTART_PRESSED_RED,
			BUTTON_EXIT_RED,
			BUTTON_EXIT_PRESSED_RED
		)
	else:
		match_result_label_node.texture = TEXT_PLAYER_1_WINS if winner == "left" else TEXT_PLAYER_2_WINS
		match_result_panel_style.texture = MATCH_RESULT_PANEL_BLUE
		_set_match_result_button_textures(
			BUTTON_RESTART_BLUE,
			BUTTON_RESTART_PRESSED_BLUE,
			BUTTON_EXIT_BLUE,
			BUTTON_EXIT_PRESSED_BLUE
		)
	
	match_result_label_node.visible = true
	match_result_panel_node.visible = true

func _set_match_result_button_textures(
	restart_normal: Texture2D,
	restart_pressed: Texture2D,
	exit_normal: Texture2D,
	exit_pressed: Texture2D
) -> void:
	restart_button_node.texture_normal = restart_normal
	restart_button_node.texture_pressed = restart_pressed
	exit_button_node.texture_normal = exit_normal
	exit_button_node.texture_pressed = exit_pressed

func _on_resume_requested() -> void:
	option_panel_node.visible = false
	get_tree().paused = false

func _on_game_mode_changed(mode: String) -> void:
	if mode == "one_player":
		game_mode = GameMode.ONE_PLAYER
	elif mode == "two_player":
		game_mode = GameMode.TWO_PLAYER

func _on_restart_requested() -> void:
	_countdown_start()
	
	match_result_panel_node.visible = false
	option_panel_node.visible = false
	
	ball_node.start_position()
	left_paddle_node.start_position()
	right_paddle_node.start_position()

func _on_exit_requested() -> void:
	get_tree().quit()
	
func _toggle_pause() -> void:
	if match_result_panel_node.visible:
		return
		
	option_panel_node.visible = !option_panel_node.visible
	
	if !countdown_texture_node.visible:
		get_tree().paused = option_panel_node.visible
	
	if option_panel_node.visible:
		countdown_node.paused = true
	else:
		countdown_node.paused = false
