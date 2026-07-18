extends PanelContainer

signal restart_requested
signal exit_requested

@onready var restart_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/RestartButton
@onready var exit_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/ExitButton

func _ready() -> void:
	restart_button.pressed.connect(_on_restart_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

func _on_restart_button_pressed() -> void:
	restart_requested.emit()

func _on_exit_button_pressed() -> void:
	exit_requested.emit()
