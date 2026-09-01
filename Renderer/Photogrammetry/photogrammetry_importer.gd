extends Node

const SUPPORTED_MODEL_EXTENSIONS := ["glb", "gltf", "obj"]

func scan_model_folder(path: String) -> Array[String]:
	var result: Array[String] = []
	var dir := DirAccess.open(path)
	if dir == null:
		return result
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and SUPPORTED_MODEL_EXTENSIONS.has(file_name.get_extension().to_lower()):
			result.append("%s/%s" % [path, file_name])
		file_name = dir.get_next()
	return result

func import_model_scene(path: String) -> PackedScene:
	if not ResourceLoader.exists(path):
		return null
	return load(path) as PackedScene

