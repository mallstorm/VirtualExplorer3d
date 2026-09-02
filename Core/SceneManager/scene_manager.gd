extends Node

signal scene_changed(scene_id: String)
signal panorama_requested(path: String)

var active_scene_id := ""
var project_data: Dictionary = {}
var pending_panorama_path := ""
var active_project_json_path := ""
var active_project_root := ""
var return_scene_path := "res://scenes/TourPlayer.tscn"
var return_scene_id := "reactor_block"

func load_project(project_json_path: String) -> bool:
	if not FileAccess.file_exists(project_json_path):
		push_warning("Project file not found: %s" % project_json_path)
		return false
	var text := FileAccess.get_file_as_string(project_json_path)
	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("Invalid project json: %s" % project_json_path)
		return false
	project_data = parsed as Dictionary
	active_project_json_path = project_json_path
	active_project_root = project_json_path.get_base_dir()
	SaveManager.set_selected_project(project_json_path)
	return true

func start_project(project_json_path: String) -> bool:
	if not load_project(project_json_path):
		return false
	active_scene_id = str(project_data.get("start_scene", "main"))
	scene_changed.emit(active_scene_id)
	get_tree().change_scene_to_file("res://scenes/TourPlayer.tscn")
	return true

func restart_active_project() -> void:
	if active_project_json_path.is_empty():
		return
	start_project(active_project_json_path)

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
	pending_panorama_path = resolve_project_path(panorama_path)
	panorama_requested.emit(panorama_path)
	if ResourceLoader.exists("res://Renderer/PanoramaRenderer/panorama_viewer.tscn"):
		get_tree().change_scene_to_file("res://Renderer/PanoramaRenderer/panorama_viewer.tscn")

func return_from_panorama() -> void:
	go_to_scene(return_scene_path, return_scene_id)

func consume_pending_panorama() -> String:
	var value: String = pending_panorama_path
	pending_panorama_path = ""
	return value

func open_first_panorama() -> void:
	for item in project_data.get("panoramas", []):
		if item is Dictionary:
			var item_data: Dictionary = item as Dictionary
			var path := str(item_data.get("path", item_data.get("panorama", "")))
			if not path.is_empty():
				open_panorama(path)
				return
	for item in project_data.get("scenes", []):
		if item is Dictionary:
			var item_data: Dictionary = item as Dictionary
			if str(item_data.get("type", "")) != "360":
				continue
			var path := str(item_data.get("panorama", ""))
			if not path.is_empty():
				open_panorama(path)
				return

func get_scene_entry(scene_id: String) -> Dictionary:
	for item in project_data.get("scenes", []):
		if item is Dictionary:
			var item_data: Dictionary = item as Dictionary
			if item_data.get("id", "") == scene_id:
				return item_data
	return {}

func get_project_display_name() -> String:
	return str(project_data.get("name", "Virtual Explorer Project"))

func resolve_project_path(path: String) -> String:
	if path.is_empty():
		return ""
	if path.begins_with("res://") or path.begins_with("user://") or path.begins_with("/"):
		return path
	if active_project_root.is_empty():
		return path
	return "%s/%s" % [active_project_root, path]
