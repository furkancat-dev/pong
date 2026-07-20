extends PanelContainer

signal resume_requested
signal restart_requested
signal exit_requested
signal game_mode_changed(mode: String)

@onready var resume_button: TextureButton = $MarginContainer/VContainer/ResumeButton
@onready var one_player_button: TextureButton = $MarginContainer/VContainer/OnePlayerButton
@onready var two_player_button: TextureButton = $MarginContainer/VContainer/TwoPlayerButton
@onready var restart_button: TextureButton = $MarginContainer/VContainer/RestartButton
@onready var exit_button: TextureButton = $MarginContainer/VContainer/ExitButton

func _ready() -> void:
	resume_button.pressed.connect(_on_resume_button_pressed)
	one_player_button.pressed.connect(_one_player_pressed)
	two_player_button.pressed.connect(_two_player_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	
	_select_game_mode("one_player")
	
func _on_resume_button_pressed() -> void:
	resume_requested.emit()
	
func _one_player_pressed() -> void:
	_select_game_mode("one_player")

func _two_player_pressed() -> void:
	_select_game_mode("two_player")
	
func _select_game_mode(mode: String) -> void:
	one_player_button.button_pressed = mode == "one_player"
	two_player_button.button_pressed = mode == "two_player"
	game_mode_changed.emit(mode)

func _on_restart_button_pressed() -> void:
	restart_requested.emit()

func _on_exit_button_pressed() -> void:
	exit_requested.emit()
