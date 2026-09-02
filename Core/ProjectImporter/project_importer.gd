extends Node

const IMPORT_ROOT := "user://Explorer/Projects"
const DEFAULT_IMPORT_FILES := [
	"user://Import/Chernobyl_Sarcophagus_Experience.zip",
	"/storage/emulated/0/Download/Chernobyl_Sarcophagus_Experience.zip",
	"/storage/emulated/0/Downloads/Chernobyl_Sarcophagus_Experience.zip"
]

func import_zip(zip_path: String) -> String:
	var reader := ZIPReader.new()
	var err := reader.open(zip_path)
	if err != OK:
		push_warning("Could not open project zip: %s" % zip_path)
		return ""

	var project_name := zip_path.get_file().get_basename()
	var destination := "%s/%s" % [IMPORT_ROOT, project_name]
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(destination))

	for packed_path in reader.get_files():
		if _is_unsafe_zip_path(packed_path):
			push_warning("Skipped unsafe project zip path: %s" % packed_path)
			continue
		if packed_path.ends_with("/"):
			DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("%s/%s" % [destination, packed_path]))
			continue
		var bytes := reader.read_file(packed_path)
		var output_path := "%s/%s" % [destination, packed_path]
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output_path.get_base_dir()))
		var file := FileAccess.open(output_path, FileAccess.WRITE)
		if file:
			file.store_buffer(bytes)

	reader.close()
	var project_json: String = find_project_json(destination)
	if project_json.is_empty():
		push_warning("Imported zip has no project.json: %s" % zip_path)
		return ""
	return project_json

func _is_unsafe_zip_path(path: String) -> bool:
	return path.begins_with("/") or path.begins_with("\\") or path.contains("..") or path.contains(":")

func import_first_available_zip() -> String:
	for path in DEFAULT_IMPORT_FILES:
		var candidate: String = str(path)
		if FileAccess.file_exists(candidate):
			return import_zip(candidate)
	return ""

func list_imported_projects() -> Array[String]:
	var result: Array[String] = []
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(IMPORT_ROOT))
	var dir := DirAccess.open(IMPORT_ROOT)
	if dir == null:
		return result
	dir.list_dir_begin()
	var name := dir.get_next()
	while name != "":
		if dir.current_is_dir() and not name.begins_with("."):
			var project_json: String = find_project_json("%s/%s" % [IMPORT_ROOT, name])
			if not project_json.is_empty():
				result.append(project_json)
		name = dir.get_next()
	return result

func get_project_summary(project_json_path: String) -> Dictionary:
	if not FileAccess.file_exists(project_json_path):
		return {}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(project_json_path))
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	var data: Dictionary = parsed as Dictionary
	return {
		"id": str(data.get("id", project_json_path.get_file().get_basename())),
		"name": str(data.get("name", "Без названия")),
		"version": str(data.get("version", "")),
		"path": project_json_path
	}

func find_project_json(root: String) -> String:
	var direct := "%s/project.json" % root
	if FileAccess.file_exists(direct):
		return direct
	var dir := DirAccess.open(root)
	if dir == null:
		return ""
	dir.list_dir_begin()
	var name := dir.get_next()
	while name != "":
		if dir.current_is_dir() and not name.begins_with("."):
			var nested: String = find_project_json("%s/%s" % [root, name])
			if not nested.is_empty():
				return nested
		name = dir.get_next()
	return ""
