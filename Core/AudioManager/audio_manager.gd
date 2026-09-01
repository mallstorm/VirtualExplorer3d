extends Node

var ambience_player: AudioStreamPlayer = null
var narration_player: AudioStreamPlayer = null

func _ready() -> void:
	ambience_player = AudioStreamPlayer.new()
	ambience_player.bus = "Master"
	add_child(ambience_player)

	narration_player = AudioStreamPlayer.new()
	narration_player.bus = "Master"
	add_child(narration_player)

func play_ambience(path: String, volume_db := -10.0) -> void:
	var stream := _load_stream(path)
	if stream == null:
		return
	ambience_player.stream = stream
	ambience_player.volume_db = volume_db
	ambience_player.play()

func play_narration(path: String, volume_db := -3.0) -> void:
	var stream := _load_stream(path)
	if stream == null:
		return
	narration_player.stream = stream
	narration_player.volume_db = volume_db
	narration_player.play()

func stop_all() -> void:
	if ambience_player:
		ambience_player.stop()
	if narration_player:
		narration_player.stop()

func _load_stream(path: String) -> AudioStream:
	if path.is_empty() or not ResourceLoader.exists(path):
		return null
	return load(path) as AudioStream

