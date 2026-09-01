extends StaticBody3D

@export var object_id := ""
@export var object_name := ""
@export_multiline var description := ""
@export_file("*.mp3", "*.ogg", "*.wav") var audio_path := ""
@export var interaction := "info"

func get_interaction_data() -> Dictionary:
	return {
		"id": object_id,
		"name": object_name,
		"description": description,
		"audio": audio_path,
		"interaction": interaction
	}

