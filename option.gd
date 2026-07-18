extends PanelContainer

signal resume_requested
signal restart_requested
signal exit_requested

@onready var resume_button: TextureButton = $MarginContainer/VContainer/ResumeButton
@onready var restart_button: TextureButton = $MarginContainer/VContainer/RestartButton
@onready var exit_button: TextureButton = $MarginContainer/VContainer/ExitButton

func _ready() -> void:
	resume_button.pressed.connect(_on_resume_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	
func _on_resume_button_pressed() -> void:
	resume_requested.emit()

func _on_restart_button_pressed() -> void:
	restart_requested.emit()

func _on_exit_button_pressed() -> void:
	exit_requested.emit()
