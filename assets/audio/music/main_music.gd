extends AudioStreamPlayer

const PLAYLIST: Array[AudioStream] = [
	preload("res://assets/audio/music/gameplay-1.mp3"),
	preload("res://assets/audio/music/gameplay-2.mp3"),
]

var shuffled_playlist: Array[AudioStream] = []
var track_index := 0

func _ready() -> void:
	finished.connect(_on_finished)
	shuffled_playlist = PLAYLIST.duplicate()
	shuffled_playlist.shuffle()
	_play_track(track_index)

func _play_track(index: int) -> void:
	if shuffled_playlist.is_empty():
		return

	stream = shuffled_playlist[index]
	play()

func _on_finished() -> void:
	track_index = wrapi(track_index + 1, 0, shuffled_playlist.size())
	_play_track(track_index)
