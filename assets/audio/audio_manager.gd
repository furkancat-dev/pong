extends Node

const SETTINGS_PATH := "user://settings.cfg"
const MUSIC_BUS := &"Music"
const SFX_BUS := &"SFX"
const UI_CLICK_STREAM := preload("res://assets/audio/music/hit.wav")

var music_volume := 1.0
var sfx_volume := 1.0
var is_muted := false
var ui_click_player: AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load_settings()
	_apply_settings()
	_create_ui_click_player()
	get_tree().node_added.connect(_on_node_added)
	_connect_existing_buttons.call_deferred()

func play_ui_click() -> void:
	ui_click_player.play()

func set_music_volume(value: float) -> void:
	music_volume = clampf(value, 0.0, 1.0)
	_set_bus_volume(MUSIC_BUS, music_volume)
	_save_settings()

func set_sfx_volume(value: float) -> void:
	sfx_volume = clampf(value, 0.0, 1.0)
	_set_bus_volume(SFX_BUS, sfx_volume)
	_save_settings()

func set_muted(value: bool) -> void:
	is_muted = value
	_apply_settings()
	_save_settings()

func _apply_settings() -> void:
	_set_bus_volume(MUSIC_BUS, music_volume)
	_set_bus_volume(SFX_BUS, sfx_volume)

func _set_bus_volume(bus_name: StringName, linear_volume: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)

	if bus_index < 0:
		push_warning("Audio bus not found: %s" % bus_name)
		return

	AudioServer.set_bus_volume_db(bus_index, linear_to_db(maxf(linear_volume, 0.0001)))
	AudioServer.set_bus_mute(bus_index, is_muted or is_zero_approx(linear_volume))

func _create_ui_click_player() -> void:
	ui_click_player = AudioStreamPlayer.new()
	ui_click_player.name = "UiClickPlayer"
	ui_click_player.stream = UI_CLICK_STREAM
	ui_click_player.bus = SFX_BUS
	ui_click_player.volume_db = -14.0
	ui_click_player.pitch_scale = 1.35
	ui_click_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(ui_click_player)

func _on_node_added(node: Node) -> void:
	if node is BaseButton:
		_connect_button(node)

func _connect_existing_buttons() -> void:
	_connect_buttons_in_branch(get_tree().root)

func _connect_buttons_in_branch(node: Node) -> void:
	if node is BaseButton:
		_connect_button(node)

	for child in node.get_children():
		_connect_buttons_in_branch(child)

func _connect_button(button: BaseButton) -> void:
	if not button.pressed.is_connected(play_ui_click):
		button.pressed.connect(play_ui_click)

func _load_settings() -> void:
	var config := ConfigFile.new()

	if config.load(SETTINGS_PATH) != OK:
		return

	music_volume = clampf(
		float(config.get_value("audio", "music_volume", music_volume)),
		0.0,
		1.0
	)
	sfx_volume = clampf(
		float(config.get_value("audio", "sfx_volume", sfx_volume)),
		0.0,
		1.0
	)
	is_muted = bool(config.get_value("audio", "muted", is_muted))

func _save_settings() -> void:
	var config := ConfigFile.new()
	config.load(SETTINGS_PATH)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.set_value("audio", "muted", is_muted)
	config.save(SETTINGS_PATH)
