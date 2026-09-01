extends Node3D

const INTERACTABLE_SCRIPT := preload("res://Player/interactable_object.gd")
const PORTAL_SCRIPT := preload("res://Player/portal.gd")

var mat_floor: StandardMaterial3D
var mat_wall: StandardMaterial3D
var mat_dark: StandardMaterial3D
var mat_metal: StandardMaterial3D
var mat_rust: StandardMaterial3D
var mat_pipe: StandardMaterial3D
var mat_hazard: StandardMaterial3D
var mat_blue: StandardMaterial3D
var mat_sign: StandardMaterial3D

func _ready() -> void:
	_create_materials()
	_build_static_level()
	_build_equipment()
	_build_interactive_points()
	_build_navigation()
	_build_lighting()

func _create_materials() -> void:
	mat_floor = _mat(Color(0.24, 0.26, 0.25, 1.0), 1.0, 0.0)
	mat_wall = _mat(Color(0.42, 0.41, 0.36, 1.0), 0.95, 0.0)
	mat_dark = _mat(Color(0.08, 0.09, 0.09, 1.0), 0.8, 0.0)
	mat_metal = _mat(Color(0.18, 0.19, 0.19, 1.0), 0.55, 0.45)
	mat_rust = _mat(Color(0.45, 0.21, 0.09, 1.0), 0.85, 0.05)
	mat_pipe = _mat(Color(0.12, 0.16, 0.18, 1.0), 0.7, 0.35)
	mat_hazard = _mat(Color(0.95, 0.68, 0.12, 1.0), 0.75, 0.0)
	mat_blue = _mat(Color(0.08, 0.38, 1.0, 0.72), 0.3, 0.0, Color(0.08, 0.38, 1.0, 1.0), 1.8)
	mat_sign = _mat(Color(0.03, 0.04, 0.04, 1.0), 0.65, 0.0)

func _mat(color: Color, roughness: float, metallic: float, emission: Color = Color(0.0, 0.0, 0.0, 1.0), emission_energy: float = 0.0) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	material.metallic = metallic
	if emission_energy > 0.0:
		material.emission_enabled = true
		material.emission = emission
		material.emission_energy_multiplier = emission_energy
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	return material

func _build_static_level() -> void:
	var root := Node3D.new()
	root.name = "DemoGeometry"
	add_child(root)

	_add_zone(root, "EntranceTunnel", Vector3(0.0, 0.0, 13.0), Vector3(3.4, 0.22, 10.0), "Входной тоннель")
	_add_zone(root, "CentralHall", Vector3(0.0, 0.0, 4.0), Vector3(10.5, 0.22, 8.0), "Центральный зал")
	_add_zone(root, "ReactorBlock", Vector3(0.0, 0.0, -4.6), Vector3(12.0, 0.22, 9.2), "Реакторный блок")
	_add_zone(root, "ControlRoom", Vector3(-10.2, 0.0, -2.2), Vector3(7.2, 0.22, 5.4), "Пультовая")
	_add_zone(root, "TechnicalCorridor", Vector3(8.4, 0.0, -1.6), Vector3(4.0, 0.22, 12.0), "Технический коридор")

	_add_box(root, "EntranceLeftWall", Vector3(-1.82, 1.7, 13.0), Vector3(0.28, 3.4, 10.0), mat_wall)
	_add_box(root, "EntranceRightWall", Vector3(1.82, 1.7, 13.0), Vector3(0.28, 3.4, 10.0), mat_wall)
	_add_box(root, "EntranceGate", Vector3(0.0, 1.7, 18.05), Vector3(3.7, 3.4, 0.28), mat_dark)

	_add_box(root, "HallLeftWall", Vector3(-5.38, 1.85, 4.0), Vector3(0.3, 3.7, 8.2), mat_wall)
	_add_box(root, "HallRightWall", Vector3(5.38, 1.85, 4.0), Vector3(0.3, 3.7, 8.2), mat_wall)
	_add_box(root, "HallRearWallA", Vector3(-3.7, 1.85, 8.15), Vector3(3.4, 3.7, 0.3), mat_wall)
	_add_box(root, "HallRearWallB", Vector3(3.7, 1.85, 8.15), Vector3(3.4, 3.7, 0.3), mat_wall)

	_add_box(root, "ReactorLeftWallA", Vector3(-6.15, 1.9, -6.0), Vector3(0.3, 3.8, 6.2), mat_wall)
	_add_box(root, "ReactorLeftWallB", Vector3(-6.15, 1.9, -0.1), Vector3(0.3, 3.8, 2.0), mat_wall)
	_add_box(root, "ReactorRightWallA", Vector3(6.15, 1.9, -6.4), Vector3(0.3, 3.8, 5.4), mat_wall)
	_add_box(root, "ReactorRightWallB", Vector3(6.15, 1.9, 0.4), Vector3(0.3, 3.8, 1.2), mat_wall)
	_add_box(root, "ReactorBackWall", Vector3(0.0, 1.9, -9.35), Vector3(12.3, 3.8, 0.3), mat_wall)

	_add_box(root, "ControlOuterWall", Vector3(-13.95, 1.7, -2.2), Vector3(0.3, 3.4, 5.7), mat_wall)
	_add_box(root, "ControlBackWall", Vector3(-10.2, 1.7, -5.05), Vector3(7.5, 3.4, 0.3), mat_wall)
	_add_box(root, "ControlFrontWall", Vector3(-10.2, 1.7, 0.65), Vector3(7.5, 3.4, 0.3), mat_wall)

	_add_box(root, "CorridorOuterWall", Vector3(10.55, 1.75, -1.6), Vector3(0.3, 3.5, 12.4), mat_wall)
	_add_box(root, "CorridorBackWall", Vector3(8.4, 1.75, -7.85), Vector3(4.3, 3.5, 0.3), mat_wall)
	_add_box(root, "CorridorFrontWall", Vector3(8.4, 1.75, 4.65), Vector3(4.3, 3.5, 0.3), mat_wall)

	_add_box(root, "CentralCeiling", Vector3(0.0, 3.7, 2.0), Vector3(10.5, 0.22, 12.4), mat_dark)
	_add_box(root, "ReactorCeiling", Vector3(0.0, 4.25, -5.0), Vector3(12.0, 0.25, 8.6), mat_dark)
	_add_box(root, "SideCeiling", Vector3(-10.2, 3.45, -2.2), Vector3(7.2, 0.22, 5.4), mat_dark)
	_add_box(root, "CorridorCeiling", Vector3(8.4, 3.5, -1.6), Vector3(4.0, 0.22, 12.0), mat_dark)

func _add_zone(parent: Node3D, zone_name: String, position: Vector3, size: Vector3, label_text: String) -> void:
	_add_box(parent, "%sFloor" % zone_name, position, size, mat_floor)
	var label := Label3D.new()
	label.name = "%sLabel" % zone_name
	label.text = label_text
	label.position = position + Vector3(0.0, 0.08, size.z * -0.28)
	label.rotation_degrees.x = -90.0
	label.pixel_size = 0.028
	label.modulate = Color(0.75, 0.82, 0.86, 0.62)
	parent.add_child(label)

func _build_equipment() -> void:
	var root := Node3D.new()
	root.name = "DemoEquipment"
	add_child(root)

	_add_box(root, "ReactorCoreBase", Vector3(0.0, 0.45, -5.8), Vector3(3.4, 0.9, 2.8), mat_metal)
	_add_box(root, "ReactorCoreTop", Vector3(0.0, 1.35, -5.8), Vector3(2.5, 0.9, 2.0), mat_rust)
	_add_box(root, "ShieldBlockA", Vector3(-2.7, 0.7, -6.7), Vector3(1.2, 1.4, 1.6), mat_wall)
	_add_box(root, "ShieldBlockB", Vector3(2.7, 0.7, -4.8), Vector3(1.2, 1.4, 1.6), mat_wall)
	_add_box(root, "CollapsedBeamA", Vector3(-1.8, 1.65, -2.8), Vector3(0.35, 0.35, 4.8), mat_rust, Vector3(0.0, 0.0, -18.0))
	_add_box(root, "CollapsedBeamB", Vector3(2.3, 1.35, -7.4), Vector3(0.3, 0.3, 3.8), mat_rust, Vector3(0.0, 0.0, 26.0))

	for i in range(4):
		var x := -4.2 + float(i) * 2.8
		_add_box(root, "FloorPipe%d" % i, Vector3(x, 0.18, -1.0), Vector3(0.22, 0.22, 5.8), mat_pipe)
		_add_box(root, "OverheadPipe%d" % i, Vector3(x, 2.85, 2.0), Vector3(0.18, 0.18, 8.8), mat_pipe)

	_add_box(root, "ControlDesk", Vector3(-10.5, 0.55, -2.0), Vector3(4.6, 1.1, 1.0), mat_metal)
	_add_box(root, "ControlPanelTop", Vector3(-10.5, 1.17, -2.35), Vector3(4.2, 0.18, 0.7), mat_hazard, Vector3(-18.0, 0.0, 0.0))
	for i in range(5):
		_add_box(root, "ControlButton%d" % i, Vector3(-12.1 + float(i) * 0.8, 1.35, -2.73), Vector3(0.28, 0.08, 0.18), mat_blue)

	_add_box(root, "TunnelCrateA", Vector3(-0.8, 0.45, 11.0), Vector3(0.9, 0.9, 1.2), mat_dark)
	_add_box(root, "TunnelCrateB", Vector3(0.7, 0.35, 15.2), Vector3(0.8, 0.7, 0.8), mat_rust)
	_add_box(root, "CorridorCableRack", Vector3(8.9, 1.65, -2.1), Vector3(0.35, 2.0, 8.4), mat_metal)
	_add_box(root, "EmergencyDoor", Vector3(8.4, 1.2, -7.68), Vector3(2.4, 2.4, 0.12), mat_hazard)

func _build_interactive_points() -> void:
	_add_interactable(
		"reactor_panel",
		"Пульт управления",
		"Пультовая зона реакторного блока. В демо-версии это первая интерактивная точка: можно подойти, навести прицел и открыть описание.",
		Vector3(-10.5, 1.05, -2.1),
		Vector3(2.1, 0.8, 0.45),
		mat_blue
	)
	_add_interactable(
		"reactor_core",
		"Реакторный блок",
		"Центральная зона демонстрации. Здесь показан условный защитный массив, повреждённые балки и техническое оборудование.",
		Vector3(0.0, 1.1, -5.8),
		Vector3(1.8, 1.2, 1.2),
		mat_hazard
	)
	_add_interactable(
		"entrance_checkpoint",
		"Входной тоннель",
		"Стартовая зона маршрута. Отсюда пользователь проходит внутрь саркофага к центральному залу и реакторному блоку.",
		Vector3(-1.45, 1.15, 15.8),
		Vector3(0.25, 1.0, 1.2),
		mat_sign
	)
	_add_interactable(
		"technical_corridor",
		"Технический коридор",
		"Служебный проход с кабельными трассами. Позже сюда можно добавить отдельную сцену, звук вентиляции и точки осмотра.",
		Vector3(8.65, 1.1, -2.0),
		Vector3(0.75, 1.3, 1.4),
		mat_metal
	)

func _add_interactable(object_id: String, title: String, description: String, position: Vector3, size: Vector3, material: Material) -> void:
	var body := StaticBody3D.new()
	body.name = "%sObject" % object_id
	body.position = position
	body.set_script(INTERACTABLE_SCRIPT)
	body.set("object_id", object_id)
	body.set("object_name", title)
	body.set("description", description)
	body.set("audio_path", "res://Projects/Chernobyl/audio/reactor_panel.wav")
	add_child(body)

	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	mesh.mesh = box
	mesh.material_override = material
	body.add_child(mesh)

	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)

func _build_navigation() -> void:
	_add_arrow(Vector3(0.0, 0.04, 8.8), 180.0)
	_add_arrow(Vector3(0.0, 0.04, 0.4), 180.0)
	_add_arrow(Vector3(-5.8, 0.04, -1.8), 90.0)
	_add_arrow(Vector3(5.7, 0.04, -1.6), -90.0)
	_add_portal(Vector3(3.7, 0.1, -7.1))

func _add_arrow(position: Vector3, rotation_y: float) -> void:
	var arrow := Node3D.new()
	arrow.name = "RouteArrow"
	arrow.position = position
	arrow.rotation_degrees.y = rotation_y
	add_child(arrow)
	_add_visual_box(arrow, "ArrowBody", Vector3(0.0, 0.0, 0.0), Vector3(0.22, 0.04, 1.2), mat_hazard)
	_add_visual_box(arrow, "ArrowHead", Vector3(0.0, 0.0, -0.7), Vector3(0.8, 0.04, 0.32), mat_hazard)

func _add_portal(position: Vector3) -> void:
	var portal := Area3D.new()
	portal.name = "PanoramaPortal"
	portal.position = position
	portal.set_script(PORTAL_SCRIPT)
	portal.set("target_panorama_path", "res://Projects/Chernobyl/panoramas/reactor_placeholder_360.jpg")
	add_child(portal)

	var mesh := MeshInstance3D.new()
	var cylinder := CylinderMesh.new()
	cylinder.top_radius = 0.9
	cylinder.bottom_radius = 0.9
	cylinder.height = 0.08
	cylinder.radial_segments = 48
	mesh.mesh = cylinder
	mesh.material_override = mat_blue
	portal.add_child(mesh)

	var collision := CollisionShape3D.new()
	var shape := SphereShape3D.new()
	shape.radius = 1.0
	collision.shape = shape
	portal.add_child(collision)

func _build_lighting() -> void:
	var sun := DirectionalLight3D.new()
	sun.name = "DustyTopLight"
	sun.rotation_degrees = Vector3(-58.0, -32.0, 0.0)
	sun.light_energy = 0.45
	add_child(sun)

	var points: Array[Vector3] = [
		Vector3(-1.0, 2.8, 12.0),
		Vector3(2.5, 3.0, 3.2),
		Vector3(-4.4, 2.8, -4.6),
		Vector3(5.2, 2.6, -6.3),
		Vector3(-11.8, 2.4, -2.0),
		Vector3(8.6, 2.5, 1.8)
	]
	for i in range(points.size()):
		var light := OmniLight3D.new()
		light.name = "EmergencyLight%d" % i
		light.position = points[i]
		light.light_color = Color(1.0, 0.62, 0.35, 1.0)
		light.light_energy = 1.45
		light.omni_range = 7.5
		add_child(light)

func _add_box(parent: Node3D, node_name: String, position: Vector3, size: Vector3, material: Material, rotation_degrees: Vector3 = Vector3.ZERO) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = position
	body.rotation_degrees = rotation_degrees
	parent.add_child(body)

	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	mesh.mesh = box
	mesh.material_override = material
	body.add_child(mesh)

	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)
	return body

func _add_visual_box(parent: Node3D, node_name: String, position: Vector3, size: Vector3, material: Material) -> MeshInstance3D:
	var mesh := MeshInstance3D.new()
	mesh.name = node_name
	mesh.position = position
	var box := BoxMesh.new()
	box.size = size
	mesh.mesh = box
	mesh.material_override = material
	parent.add_child(mesh)
	return mesh
