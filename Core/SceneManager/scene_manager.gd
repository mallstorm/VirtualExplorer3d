extends Node

signal scene_changed(scene_id: String)
signal panorama_requested(path: String)

var active_scene_id := ""
var project_data: Dictionary = {}
var pending_panorama_path := ""
var return_scene_path := "res://Projects/Chernobyl/scenes/reactor_room.tscn"
var return_scene_id := "reactor_block"

func load_project(project_json_path: String) -> bool:
	if not FileAccess.file_exists(project_json_path):
		push_warning("Project file not found: %s" % project_json_path)
		return false
	var text := FileAccess.get_file_as_string(project_json_path)
	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("Invalid project json: %s" % project_json_path)
		return false
	project_data = parsed
	return true

func go_to_scene(scene_path: String, scene_id: String = "") -> void:
	if scene_path.is_empty():
		return
	if not ResourceLoader.exists(scene_path):
		push_warning("Scene does not exist: %s" % scene_path)
		return
	active_scene_id = scene_id
	return_scene_path = scene_path
	return_scene_id = scene_id
	scene_changed.emit(scene_id)
	get_tree().change_scene_to_file(scene_path)

func open_panorama(panorama_path: String) -> void:
	pending_panorama_path = panorama_path
	panorama_requested.emit(panorama_path)
	if ResourceLoader.exists("res://Renderer/PanoramaRenderer/panorama_viewer.tscn"):
		get_tree().change_scene_to_file("res://Renderer/PanoramaRenderer/panorama_viewer.tscn")

func return_from_panorama() -> void:
	go_to_scene(return_scene_path, return_scene_id)

func consume_pending_panorama() -> String:
	var value: String = pending_panorama_path
	pending_panorama_path = ""
	return value

func get_scene_entry(scene_id: String) -> Dictionary:
	for item in project_data.get("scenes", []):
		if item.get("id", "") == scene_id:
			return item
	return {}
