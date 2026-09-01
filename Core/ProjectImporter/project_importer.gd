extends Node

const IMPORT_ROOT := "user://Explorer/Projects"

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
	return destination

func list_imported_projects() -> Array[String]:
	var result: Array[String] = []
	var dir := DirAccess.open(IMPORT_ROOT)
	if dir == null:
		return result
	dir.list_dir_begin()
	var name := dir.get_next()
	while name != "":
		if dir.current_is_dir() and not name.begins_with("."):
			result.append("%s/%s/project.json" % [IMPORT_ROOT, name])
		name = dir.get_next()
	return result

