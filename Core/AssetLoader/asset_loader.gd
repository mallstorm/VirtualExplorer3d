extends Node

var cache := {}

func load_scene(path: String) -> PackedScene:
	if cache.has(path):
		return cache[path]
	if not ResourceLoader.exists(path):
		push_warning("Scene asset not found: %s" % path)
		return null
	var scene := load(path) as PackedScene
	cache[path] = scene
	return scene

func load_texture(path: String) -> Texture2D:
	if cache.has(path):
		return cache[path]
	if not ResourceLoader.exists(path):
		return null
	var texture := load(path) as Texture2D
	cache[path] = texture
	return texture

