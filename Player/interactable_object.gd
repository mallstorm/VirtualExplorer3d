extends StaticBody3D

@export var object_id := ""
@export var object_name := ""
@export_multiline var description := ""
@export_file("*.mp3", "*.ogg", "*.wav") var audio_path := ""
@export var interaction := "info"
@export var inspected := false

var highlight_material: StandardMaterial3D

func get_interaction_data() -> Dictionary:
	return {
		"id": object_id,
		"name": object_name,
		"description": description,
		"audio": audio_path,
		"interaction": interaction,
		"inspected": inspected
	}

func set_focus(active: bool) -> void:
	if highlight_material == null:
		highlight_material = StandardMaterial3D.new()
		highlight_material.albedo_color = Color(0.1, 0.42, 1.0, 0.18)
		highlight_material.emission_enabled = true
		highlight_material.emission = Color(0.1, 0.42, 1.0, 1.0)
		highlight_material.emission_energy_multiplier = 0.85
		highlight_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	for child in find_children("*", "MeshInstance3D", true, false):
		var mesh := child as MeshInstance3D
		if mesh:
			mesh.material_overlay = highlight_material if active else null

func mark_inspected() -> void:
	inspected = true
