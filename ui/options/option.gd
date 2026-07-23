extends PanelContainer

signal resume_requested
signal restart_requested
signal exit_requested
signal game_mode_changed(mode: String)

@onready var main_options_page: VBoxContainer = $MarginContainer/VContainer
@onready var resume_button: TextureButton = $MarginContainer/VContainer/ResumeButton
@onready var one_player_button: TextureButton = $MarginContainer/VContainer/OnePlayerButton
@onready var two_player_button: TextureButton = $MarginContainer/VContainer/TwoPlayerButton
@onready var difficulty_panel: DifficultyPanel = $MarginContainer/VContainer/DifficultyPanel
@onready var audio_settings_button: Button = $MarginContainer/VContainer/AudioSettingsButton
@onready var restart_button: TextureButton = $MarginContainer/VContainer/RestartButton
@onready var exit_button: TextureButton = $MarginContainer/VContainer/ExitButton
@onready var audio_settings_page: AudioSettings = $MarginContainer/AudioSettings

func _ready() -> void:
	resume_button.pressed.connect(_on_resume_button_pressed)
	one_player_button.pressed.connect(_on_one_player_button_pressed)
	two_player_button.pressed.connect(_on_two_player_button_pressed)
	audio_settings_button.pressed.connect(_show_audio_settings_page)
	restart_button.pressed.connect(_on_restart_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	audio_settings_page.back_requested.connect(_show_main_options_page)
	visibility_changed.connect(_on_visibility_changed)
	
	_select_game_mode("one_player")
	_show_main_options_page()
	
func _on_resume_button_pressed() -> void:
	resume_requested.emit()
	
func _on_one_player_button_pressed() -> void:
	_select_game_mode("one_player")

func _on_two_player_button_pressed() -> void:
	_select_game_mode("two_player")
	
func _select_game_mode(mode: String) -> void:
	one_player_button.button_pressed = mode == "one_player"
	two_player_button.button_pressed = mode == "two_player"
	
	difficulty_panel.set_difficulty_enabled(mode == "one_player")
	game_mode_changed.emit(mode)

func _on_restart_button_pressed() -> void:
	restart_requested.emit()

func _on_exit_button_pressed() -> void:
	exit_requested.emit()

func _show_audio_settings_page() -> void:
	main_options_page.visible = false
	audio_settings_page.visible = true

func _show_main_options_page() -> void:
	audio_settings_page.visible = false
	main_options_page.visible = true

func _on_visibility_changed() -> void:
	if visible:
		_show_main_options_page()
