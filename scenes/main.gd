extends Node

func _ready() -> void:
	SceneManager.load_project("res://Projects/Chernobyl/project.json")
	AudioManager.play_ambience("res://Projects/Chernobyl/audio/reactor_room_ambience.wav")
