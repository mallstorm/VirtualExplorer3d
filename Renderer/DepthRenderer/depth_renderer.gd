extends Node

var depth_map: Texture2D = null
var reconstruction_strength := 0.0

func load_depth_map(path: String) -> bool:
	depth_map = AssetLoader.load_texture(path)
	return depth_map != null

func estimate_depth_from_panorama(_panorama_path: String) -> Dictionary:
	return {
		"status": "planned",
		"module": "AI Depth",
		"note": "External AI depth service is not bundled into MVP to keep APK small."
	}

func apply_depth_to_mesh(_mesh_instance: MeshInstance3D) -> bool:
	if depth_map == null:
		return false
	return true

