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
	var texture: Texture2D = null
	if ResourceLoader.exists(path):
		texture = load(path) as Texture2D
	elif FileAccess.file_exists(path):
		var image := Image.new()
		if image.load(path) == OK:
			texture = ImageTexture.create_from_image(image)
	if texture == null:
		return null
	cache[path] = texture
	return texture
