class_name AudioSettings
extends VBoxContainer

signal back_requested

@onready var music_slider: HSlider = $MusicRow/MusicSlider
@onready var music_value_label: Label = $MusicRow/MusicValue
@onready var sfx_slider: HSlider = $SFXRow/SFXSlider
@onready var sfx_value_label: Label = $SFXRow/SFXValue
@onready var mute_button: CheckButton = $MuteButton
@onready var back_button: Button = $BackButton

func _ready() -> void:
	music_slider.set_value_no_signal(AudioManager.music_volume)
	sfx_slider.set_value_no_signal(AudioManager.sfx_volume)
	mute_button.set_pressed_no_signal(AudioManager.is_muted)
	_update_value_labels()

	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	mute_button.toggled.connect(_on_mute_toggled)
	back_button.pressed.connect(_on_back_pressed)

func _on_music_volume_changed(value: float) -> void:
	AudioManager.set_music_volume(value)
	_update_value_labels()

func _on_sfx_volume_changed(value: float) -> void:
	AudioManager.set_sfx_volume(value)
	_update_value_labels()

func _on_mute_toggled(is_muted: bool) -> void:
	AudioManager.set_muted(is_muted)

func _on_back_pressed() -> void:
	back_requested.emit()

func _update_value_labels() -> void:
	music_value_label.text = "%d%%" % roundi(music_slider.value * 100.0)
	sfx_value_label.text = "%d%%" % roundi(sfx_slider.value * 100.0)
