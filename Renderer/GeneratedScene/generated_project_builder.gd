extends Node3D

const INTERACTABLE_SCRIPT := preload("res://Player/interactable_object.gd")
const PORTAL_SCRIPT := preload("res://Player/portal.gd")

var materials := {}

func _ready() -> void:
	_create_default_materials()
	_build_from_project()

func _create_default_materials() -> void:
	materials = {
		"floor": _mat(Color(0.24, 0.26, 0.25, 1.0), 1.0, 0.0),
		"wall": _mat(Color(0.42, 0.41, 0.36, 1.0), 0.95, 0.0),
		"dark": _mat(Color(0.08, 0.09, 0.09, 1.0), 0.8, 0.0),
		"metal": _mat(Color(0.18, 0.19, 0.19, 1.0), 0.55, 0.45),
		"rust": _mat(Color(0.45, 0.21, 0.09, 1.0), 0.85, 0.05),
		"pipe": _mat(Color(0.12, 0.16, 0.18, 1.0), 0.7, 0.35),
		"hazard": _mat(Color(0.95, 0.68, 0.12, 1.0), 0.75, 0.0),
		"blue": _mat(Color(0.08, 0.38, 1.0, 0.72), 0.3, 0.0, Color(0.08, 0.38, 1.0, 1.0), 1.8),
		"sign": _mat(Color(0.03, 0.04, 0.04, 1.0), 0.65, 0.0),
		"white": _mat(Color(0.72, 0.76, 0.73, 0.86), 0.9, 0.0),
		"red": _mat(Color(0.62, 0.06, 0.04, 0.9), 0.82, 0.0),
		"stain": _mat(Color(0.04, 0.045, 0.04, 0.55), 1.0, 0.0),
		"dust": _mat(Color(0.82, 0.76, 0.62, 0.28), 1.0, 0.0),
		"exit": _mat(Color(0.05, 0.55, 0.24, 0.9), 0.65, 0.0, Color(0.04, 0.45, 0.2, 1.0), 0.7)
	}

func _mat(color: Color, roughness: float, metallic: float, emission: Color = Color(0, 0, 0, 1), emission_energy: float = 0.0) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	material.metallic = metallic
	if color.a < 1.0:
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	if emission_energy > 0.0:
		material.emission_enabled = true
		material.emission = emission
		material.emission_energy_multiplier = emission_energy
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	return material

func _build_from_project() -> void:
	var data: Dictionary = SceneManager.project_data
	if data.is_empty():
		_build_empty_scene()
		return
	var scene_value: Variant = data.get("tour_scene", {})
	var scene: Dictionary = scene_value if scene_value is Dictionary else {}
	if scene.is_empty():
		_build_empty_scene()
		return

	_apply_spawn(scene.get("spawn", {}))
	_build_environment(scene.get("environment", {}))
	_build_zones(_array(scene.get("zones", [])))
	_build_boxes(_array(scene.get("boxes", [])), true)
	_build_boxes(_array(scene.get("visual_boxes", [])), false)
	_build_labels(_array(scene.get("labels", [])))
	_build_interactables(_array(scene.get("interactables", [])))
	_build_portals(_array(scene.get("portals", [])))
	_build_lights(_array(scene.get("lights", [])))
	_play_ambience(data.get("audio", {}))

func _build_empty_scene() -> void:
	_add_box(self, "FallbackFloor", Vector3.ZERO, Vector3(8, 0.2, 8), _material("floor"), true)
	_add_label(self, "Нет установленного проекта", Vector3(0, 1.6, -2.5), Vector3(0, 0, 0), Color(1, 1, 1, 1), 0.035)

func _apply_spawn(spawn_data: Variant) -> void:
	if not spawn_data is Dictionary:
		return
	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return
	player.global_position = _vec3(spawn_data.get("position", [0, 0.12, 0]), Vector3(0, 0.12, 0))
	player.rotation_degrees = _vec3(spawn_data.get("rotation", [0, 0, 0]), Vector3.ZERO)

func _build_environment(data: Variant) -> void:
	var environment_data: Dictionary = {}
	if data is Dictionary:
		environment_data = data
	var world := WorldEnvironment.new()
	world.name = "ProjectWorldEnvironment"
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = _color(environment_data.get("background", [0.025, 0.028, 0.026, 1]), Color(0.025, 0.028, 0.026, 1))
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = _color(environment_data.get("ambient_color", [0.22, 0.24, 0.22, 1]), Color(0.22, 0.24, 0.22, 1))
	environment.ambient_light_energy = float(environment_data.get("ambient_energy", 0.22))
	world.environment = environment
	add_child(world)

func _build_zones(items: Array) -> void:
	var root := Node3D.new()
	root.name = "Zones"
	add_child(root)
	for item in items:
		if not item is Dictionary:
			continue
		var item_data: Dictionary = item as Dictionary
		var position := _vec3(item_data.get("position", [0, 0, 0]), Vector3.ZERO)
		var size := _vec3(item_data.get("size", [6, 0.22, 6]), Vector3(6, 0.22, 6))
		_add_box(root, str(item_data.get("id", "ZoneFloor")), position, size, _material(str(item_data.get("material", "floor"))), true)
		_add_label(root, str(item_data.get("name", "")), position + Vector3(0, 0.08, size.z * -0.28), Vector3(-90, 0, 0), Color(0.75, 0.82, 0.86, 0.62), 0.028)

func _build_boxes(items: Array, collision: bool) -> void:
	var root := Node3D.new()
	root.name = "CollisionBoxes" if collision else "VisualBoxes"
	add_child(root)
	for item in items:
		if not item is Dictionary:
			continue
		var item_data: Dictionary = item as Dictionary
		_add_box(
			root,
			str(item_data.get("name", "Box")),
			_vec3(item_data.get("position", [0, 0, 0]), Vector3.ZERO),
			_vec3(item_data.get("size", [1, 1, 1]), Vector3.ONE),
			_material(str(item_data.get("material", "wall"))),
			collision,
			_vec3(item_data.get("rotation", [0, 0, 0]), Vector3.ZERO)
		)

func _build_labels(items: Array) -> void:
	var root := Node3D.new()
	root.name = "Labels"
	add_child(root)
	for item in items:
		if not item is Dictionary:
			continue
		var item_data: Dictionary = item as Dictionary
		_add_label(
			root,
			str(item_data.get("text", "")),
			_vec3(item_data.get("position", [0, 1, 0]), Vector3.ZERO),
			_vec3(item_data.get("rotation", [0, 0, 0]), Vector3.ZERO),
			_color(item_data.get("color", [1, 1, 1, 1]), Color(1, 1, 1, 1)),
			float(item_data.get("pixel_size", 0.022))
		)

func _build_interactables(items: Array) -> void:
	var root := Node3D.new()
	root.name = "Interactables"
	add_child(root)
	for item in items:
		if not item is Dictionary:
			continue
		var item_data: Dictionary = item as Dictionary
		var body := StaticBody3D.new()
		body.name = "%sObject" % str(item_data.get("id", "interactive"))
		body.position = _vec3(item_data.get("position", [0, 1, 0]), Vector3.ZERO)
		body.rotation_degrees = _vec3(item_data.get("rotation", [0, 0, 0]), Vector3.ZERO)
		body.set_script(INTERACTABLE_SCRIPT)
		body.set("object_id", str(item_data.get("id", "")))
		body.set("object_name", str(item_data.get("name", "Объект")))
		body.set("description", str(item_data.get("description", "")))
		body.set("audio_path", SceneManager.resolve_project_path(str(item_data.get("audio", ""))))
		root.add_child(body)
		_add_mesh_and_collision(body, _vec3(item_data.get("size", [1, 1, 1]), Vector3.ONE), _material(str(item_data.get("material", "blue"))), true)

func _build_portals(items: Array) -> void:
	var root := Node3D.new()
	root.name = "Portals"
	add_child(root)
	for item in items:
		if not item is Dictionary:
			continue
		var item_data: Dictionary = item as Dictionary
		var portal := Area3D.new()
		portal.name = str(item_data.get("name", "Portal"))
		portal.position = _vec3(item_data.get("position", [0, 0.1, 0]), Vector3.ZERO)
		portal.rotation_degrees = _vec3(item_data.get("rotation", [0, 0, 0]), Vector3.ZERO)
		portal.set_script(PORTAL_SCRIPT)
		portal.set("target_panorama_path", str(item_data.get("panorama", "")))
		root.add_child(portal)

		var mesh := MeshInstance3D.new()
		var cylinder := CylinderMesh.new()
		cylinder.top_radius = float(item_data.get("radius", 0.9))
		cylinder.bottom_radius = float(item_data.get("radius", 0.9))
		cylinder.height = 0.08
		cylinder.radial_segments = 48
		mesh.mesh = cylinder
		mesh.material_override = _material(str(item_data.get("material", "blue")))
		portal.add_child(mesh)

		var collision := CollisionShape3D.new()
		var shape := SphereShape3D.new()
		shape.radius = float(item_data.get("trigger_radius", 1.0))
		collision.shape = shape
		portal.add_child(collision)

func _build_lights(items: Array) -> void:
	for item in items:
		if not item is Dictionary:
			continue
		var item_data: Dictionary = item as Dictionary
		var light_type := str(item_data.get("type", "omni"))
		if light_type == "directional":
			var sun := DirectionalLight3D.new()
			sun.name = str(item_data.get("name", "DirectionalLight"))
			sun.rotation_degrees = _vec3(item_data.get("rotation", [-58, -32, 0]), Vector3(-58, -32, 0))
			sun.light_energy = float(item_data.get("energy", 0.45))
			add_child(sun)
		else:
			var light := OmniLight3D.new()
			light.name = str(item_data.get("name", "OmniLight"))
			light.position = _vec3(item_data.get("position", [0, 2, 0]), Vector3.ZERO)
			light.light_color = _color(item_data.get("color", [1, 0.62, 0.35, 1]), Color(1, 0.62, 0.35, 1))
			light.light_energy = float(item_data.get("energy", 1.45))
			light.omni_range = float(item_data.get("range", 7.5))
			add_child(light)

func _play_ambience(audio_data: Variant) -> void:
	if not audio_data is Dictionary:
		return
	var path: String = SceneManager.resolve_project_path(str(audio_data.get("ambience", "")))
	if not path.is_empty():
		AudioManager.play_ambience(path)

func _add_box(parent: Node3D, node_name: String, position: Vector3, size: Vector3, material: Material, collision: bool, rotation: Vector3 = Vector3.ZERO) -> Node3D:
	var node: Node3D
	if collision:
		node = StaticBody3D.new()
	else:
		node = MeshInstance3D.new()
	node.name = node_name
	node.position = position
	node.rotation_degrees = rotation
	parent.add_child(node)
	if collision:
		_add_mesh_and_collision(node, size, material, true)
	else:
		var mesh_node := node as MeshInstance3D
		if mesh_node == null:
			return node
		var box := BoxMesh.new()
		box.size = size
		mesh_node.mesh = box
		mesh_node.material_override = material
	return node

func _add_mesh_and_collision(parent: Node3D, size: Vector3, material: Material, collision_enabled: bool) -> void:
	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	mesh.mesh = box
	mesh.material_override = material
	parent.add_child(mesh)
	if collision_enabled:
		var collision := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = size
		collision.shape = shape
		parent.add_child(collision)

func _add_label(parent: Node3D, text: String, position: Vector3, rotation: Vector3, color: Color, pixel_size: float) -> void:
	if text.is_empty():
		return
	var label := Label3D.new()
	label.name = "Label"
	label.text = text
	label.position = position
	label.rotation_degrees = rotation
	label.pixel_size = pixel_size
	label.modulate = color
	parent.add_child(label)

func _material(name: String) -> Material:
	if materials.has(name):
		var material: Material = materials[name] as Material
		return material
	var fallback: Material = materials["wall"] as Material
	return fallback

func _vec3(value: Variant, fallback: Vector3) -> Vector3:
	if value is Array and value.size() >= 3:
		return Vector3(float(value[0]), float(value[1]), float(value[2]))
	return fallback

func _color(value: Variant, fallback: Color) -> Color:
	if value is Array and value.size() >= 4:
		return Color(float(value[0]), float(value[1]), float(value[2]), float(value[3]))
	return fallback

func _array(value: Variant) -> Array:
	if value is Array:
		return value as Array
	return []
