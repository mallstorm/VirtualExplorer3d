extends Node3D

@export_file("*.jpg", "*.jpeg", "*.png") var panorama_path := ""
@export var look_sensitivity := 0.004

@onready var sphere: MeshInstance3D = $PanoramaSphere
@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var return_button: Button = $PanoramaHUD/Root/ReturnButton
@onready var title_label: Label = $PanoramaHUD/Root/Title

func _ready() -> void:
	camera.current = true
	var pending: String = SceneManager.consume_pending_panorama()
	if not pending.is_empty():
		panorama_path = pending
	load_panorama(panorama_path)
	return_button.pressed.connect(_on_return_pressed)
	title_label.text = "360 обзорная точка"
	if OS.get_name() != "Android":
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_apply_look(event.relative * look_sensitivity)
	if event is InputEventScreenDrag:
		_apply_look(event.relative * look_sensitivity * 1.4)
	if event.is_action_pressed("ui_cancel"):
		_on_return_pressed()

func load_panorama(path: String) -> void:
	var material := StandardMaterial3D.new()
	material.cull_mode = BaseMaterial3D.CULL_FRONT
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	var texture := AssetLoader.load_texture(path)
	if texture:
		material.albedo_texture = texture
	else:
		material.albedo_color = Color(0.18, 0.2, 0.22, 1)
	sphere.material_override = material

func _apply_look(delta_pixels: Vector2) -> void:
	camera_pivot.rotate_y(-delta_pixels.x)
	camera.rotation.x = clamp(camera.rotation.x - delta_pixels.y, -1.52, 1.52)

func _on_return_pressed() -> void:
	SceneManager.return_from_panorama()
