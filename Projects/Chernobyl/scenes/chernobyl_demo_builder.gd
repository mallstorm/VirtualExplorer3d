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
var mat_marking_white: StandardMaterial3D
var mat_marking_red: StandardMaterial3D
var mat_stain: StandardMaterial3D
var mat_dust: StandardMaterial3D
var mat_exit_green: StandardMaterial3D

func _ready() -> void:
	_create_materials()
	_build_static_level()
	_build_equipment()
	_build_visual_detail()
	_build_interactive_points()
	_build_navigation()
	_build_lighting()
	_build_atmosphere()

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
	mat_marking_white = _mat(Color(0.72, 0.76, 0.73, 0.86), 0.9, 0.0)
	mat_marking_red = _mat(Color(0.62, 0.06, 0.04, 0.9), 0.82, 0.0)
	mat_stain = _mat(Color(0.04, 0.045, 0.04, 0.55), 1.0, 0.0)
	mat_dust = _mat(Color(0.82, 0.76, 0.62, 0.28), 1.0, 0.0)
	mat_exit_green = _mat(Color(0.05, 0.55, 0.24, 0.9), 0.65, 0.0, Color(0.04, 0.45, 0.2, 1.0), 0.7)

func _mat(color: Color, roughness: float, metallic: float, emission: Color = Color(0.0, 0.0, 0.0, 1.0), emission_energy: float = 0.0) -> StandardMaterial3D:
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

func _build_visual_detail() -> void:
	var root := Node3D.new()
	root.name = "VisualDetail"
	add_child(root)
	_build_floor_markings(root)
	_build_wall_signs(root)
	_build_wall_damage(root)
	_build_control_room_details(root)
	_build_corridor_cables(root)
	_build_dust_markers(root)

func _build_floor_markings(root: Node3D) -> void:
	for z in [15.0, 12.8, 10.6, 7.6, 4.8, 1.8, -1.0, -3.8, -6.4]:
		_add_visual_box(root, "CenterLine", Vector3(0.0, 0.125, z), Vector3(0.12, 0.025, 1.1), mat_marking_white)
	_add_visual_box(root, "ReactorWarningLineA", Vector3(-3.4, 0.13, -5.8), Vector3(0.14, 0.025, 4.4), mat_hazard)
	_add_visual_box(root, "ReactorWarningLineB", Vector3(3.4, 0.13, -5.8), Vector3(0.14, 0.025, 4.4), mat_hazard)
	_add_visual_box(root, "ControlRoomLine", Vector3(-8.1, 0.13, -2.1), Vector3(3.1, 0.025, 0.14), mat_marking_red)
	_add_hazard_stripes(root, Vector3(8.4, 0.15, -7.0), 5, 0.0)

func _build_wall_signs(root: Node3D) -> void:
	_add_wall_label(root, "SIGN A-01 / ВХОД", Vector3(0.0, 2.4, 17.88), Vector3(0.0, 180.0, 0.0), Color(0.85, 0.9, 0.82, 1.0))
	_add_wall_label(root, "ЦЕНТРАЛЬНЫЙ ЗАЛ", Vector3(-5.22, 2.15, 4.0), Vector3(0.0, 90.0, 0.0), Color(0.82, 0.86, 0.78, 1.0))
	_add_wall_label(root, "РЕАКТОРНЫЙ БЛОК N4", Vector3(0.0, 2.6, -9.18), Vector3(0.0, 0.0, 0.0), Color(1.0, 0.74, 0.28, 1.0))
	_add_wall_label(root, "ПУЛЬТОВАЯ", Vector3(-13.78, 2.15, -2.2), Vector3(0.0, 90.0, 0.0), Color(0.78, 0.88, 1.0, 1.0))
	_add_wall_label(root, "ТЕХНИЧЕСКИЙ КОРИДОР", Vector3(10.38, 2.12, -1.6), Vector3(0.0, -90.0, 0.0), Color(0.82, 0.86, 0.78, 1.0))
	_add_visual_box(root, "ExitSign", Vector3(8.4, 2.62, -7.52), Vector3(1.7, 0.12, 0.42), mat_exit_green)
	_add_wall_label(root, "EXIT", Vector3(8.4, 2.65, -7.44), Vector3(0.0, 0.0, 0.0), Color(0.8, 1.0, 0.86, 1.0), 0.026)

func _build_wall_damage(root: Node3D) -> void:
	_add_visual_box(root, "WallStainEntranceA", Vector3(-1.66, 2.25, 12.0), Vector3(0.035, 1.2, 2.1), mat_stain)
	_add_visual_box(root, "WallStainEntranceB", Vector3(1.66, 1.45, 14.8), Vector3(0.035, 0.9, 1.6), mat_stain)
	_add_visual_box(root, "WallStainHallA", Vector3(-5.2, 2.35, 1.5), Vector3(0.035, 1.0, 2.4), mat_stain)
	_add_visual_box(root, "WallStainHallB", Vector3(5.2, 2.1, 5.6), Vector3(0.035, 1.2, 1.8), mat_stain)
	_add_visual_box(root, "WallStainReactor", Vector3(0.8, 2.4, -9.17), Vector3(2.6, 1.1, 0.035), mat_stain)
	_add_visual_box(root, "WallStainControl", Vector3(-13.78, 1.55, -3.2), Vector3(0.035, 0.8, 2.0), mat_stain)
	for x in [-4.6, -2.0, 2.0, 4.5]:
		_add_visual_box(root, "ReactorWallPanel", Vector3(x, 1.25, -9.15), Vector3(1.1, 1.2, 0.06), mat_dark)

func _build_control_room_details(root: Node3D) -> void:
	for i in range(6):
		var x := -12.45 + float(i) * 0.78
		_add_visual_box(root, "IndicatorBlue%d" % i, Vector3(x, 1.52, -2.72), Vector3(0.22, 0.04, 0.16), mat_blue)
	for i in range(4):
		var x := -12.1 + float(i) * 0.9
		_add_visual_box(root, "PanelSlot%d" % i, Vector3(x, 1.42, -2.34), Vector3(0.52, 0.04, 0.08), mat_dark)
	_add_wall_label(root, "RBMK CONTROL NODE", Vector3(-10.5, 1.78, -2.88), Vector3(-18.0, 0.0, 0.0), Color(0.72, 0.9, 1.0, 1.0), 0.018)

func _build_corridor_cables(root: Node3D) -> void:
	for i in range(5):
		var y := 0.9 + float(i) * 0.32
		_add_visual_box(root, "CableLine%d" % i, Vector3(8.68, y, -2.1), Vector3(0.08, 0.05, 8.1), mat_pipe)
	for z in [-5.6, -3.6, -1.6, 0.4, 2.4]:
		_add_visual_box(root, "CableClamp", Vector3(8.62, 1.55, z), Vector3(0.16, 1.5, 0.08), mat_rust)

func _build_dust_markers(root: Node3D) -> void:
	for i in range(20):
		var x := -5.0 + float((i * 37) % 100) / 10.0
		var z := -7.2 + float((i * 19) % 210) / 10.0
		var y := 1.0 + float((i * 11) % 20) / 10.0
		_add_visual_box(root, "DustMote%d" % i, Vector3(x, y, z), Vector3(0.035, 0.035, 0.035), mat_dust)

func _add_hazard_stripes(root: Node3D, position: Vector3, count: int, rotation_y: float) -> void:
	for i in range(count):
		var stripe := _add_visual_box(root, "HazardStripe%d" % i, position + Vector3(float(i) * 0.42 - 0.84, 0.0, 0.0), Vector3(0.24, 0.025, 1.15), mat_hazard)
		stripe.rotation_degrees.y = rotation_y + 28.0

func _add_wall_label(root: Node3D, text: String, position: Vector3, rotation: Vector3, color: Color, pixel_size: float = 0.022) -> void:
	var label := Label3D.new()
	label.name = "WallLabel"
	label.text = text
	label.position = position
	label.rotation_degrees = rotation
	label.pixel_size = pixel_size
	label.modulate = color
	root.add_child(label)

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
	_add_interactable(
		"collapsed_beam",
		"Повреждённая балка",
		"Фрагмент условной конструкции саркофага. Такие детали нужны для ощущения масштаба и разрушенного промышленного пространства.",
		Vector3(-1.8, 1.65, -2.8),
		Vector3(0.55, 0.55, 1.4),
		mat_rust
	)
	_add_interactable(
		"emergency_exit",
		"Аварийная дверь",
		"Маркер будущего перехода в отдельную сцену технического коридора. В этой версии дверь работает как точка осмотра.",
		Vector3(8.4, 1.2, -7.45),
		Vector3(1.7, 1.6, 0.2),
		mat_exit_green
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

func _build_atmosphere() -> void:
	var world := WorldEnvironment.new()
	world.name = "DemoWorldEnvironment"
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.025, 0.028, 0.026, 1.0)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.22, 0.24, 0.22, 1.0)
	environment.ambient_light_energy = 0.22
	world.environment = environment
	add_child(world)

	var haze_root := Node3D.new()
	haze_root.name = "HazeSheets"
	add_child(haze_root)
	_add_visual_box(haze_root, "CentralDustHaze", Vector3(0.0, 2.7, 1.0), Vector3(9.8, 0.04, 8.0), mat_dust)
	_add_visual_box(haze_root, "ReactorDustHaze", Vector3(0.0, 3.0, -5.8), Vector3(10.2, 0.04, 6.4), mat_dust)
	_add_visual_box(haze_root, "TunnelDustHaze", Vector3(0.0, 2.45, 13.2), Vector3(3.0, 0.04, 7.0), mat_dust)

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
