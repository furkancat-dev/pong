class_name DifficultyPanel
extends HBoxContainer

signal difficulty_changed(difficulty: int)

const DIFFICULTIES := [
	BotPaddle.Difficulty.EASY,
	BotPaddle.Difficulty.NORMAL,
	BotPaddle.Difficulty.HARD,
]
const EASY_TEXTURE := preload("res://assets/difficulty_easy.png")
const NORMAL_TEXTURE := preload("res://assets/difficulty_normal.png")
const HARD_TEXTURE := preload("res://assets/difficulty_hard.png")
const TEXTURES := [
	EASY_TEXTURE,
	NORMAL_TEXTURE,
	HARD_TEXTURE,
]

var difficulty_index := 1

@onready var prev_button: TextureButton = $PrevButton
@onready var difficulty_node: TextureRect = $Difficulty
@onready var next_button: TextureButton = $NextButton

func _ready() -> void:
	prev_button.pressed.connect(_on_prev_button_clicked)
	next_button.pressed.connect(_on_next_button_clicked)

func set_difficulty_enabled(is_enabled: bool) -> void:
	prev_button.disabled = not is_enabled
	next_button.disabled = not is_enabled
	modulate = Color.WHITE if is_enabled else Color(1.0, 1.0, 1.0, 0.45)

func _on_prev_button_clicked() -> void:
	_change_difficulty(-1)
	
func _on_next_button_clicked() -> void:
	_change_difficulty(1)
	
func _change_difficulty(direction: int) -> void:
	difficulty_index = wrapi(
		difficulty_index + direction,
		0,
		DIFFICULTIES.size()
	)
	
	var tween = create_tween()
	tween.tween_property(difficulty_node, "scale", Vector2(0.9, 0.9), 0.08)
	tween.tween_callback(_update_difficulty_texture)
	tween.tween_property(difficulty_node, "scale", Vector2.ONE, 0.08)

	difficulty_changed.emit(DIFFICULTIES[difficulty_index])
	
func _update_difficulty_texture() -> void:
	difficulty_node.texture = TEXTURES[difficulty_index]
