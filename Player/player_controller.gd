extends CharacterBody3D

@export var speed := 3.5
@export var acceleration := 10.0
@export var mouse_sensitivity := 0.002
@export var touch_sensitivity := 0.006
@export var touch_look_speed := 2.2
@export var camera_height := 1.75
@export var min_pitch := -1.52
@export var max_pitch := 1.52

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var look_touch_index := -1

func _ready() -> void:
	camera_pivot.position.y = camera_height
	camera.fov = 78.0
	if OS.get_name() != "Android":
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_apply_look(event.relative * mouse_sensitivity)
	if event is InputEventScreenDrag:
		var viewport_width := get_viewport().get_visible_rect().size.x
		if event.position.x > viewport_width * 0.42:
			look_touch_index = event.index
			_apply_look(event.relative * touch_sensitivity)
	if event is InputEventScreenTouch and not event.pressed and event.index == look_touch_index:
		look_touch_index = -1

func _physics_process(delta: float) -> void:
	var input_vec: Vector2 = InputManager.get_move_vector()
	var direction := (global_transform.basis * Vector3(input_vec.x, 0.0, input_vec.y)).normalized()
	var target_velocity := direction * speed

	velocity.x = move_toward(velocity.x, target_velocity.x, acceleration * delta)
	velocity.z = move_toward(velocity.z, target_velocity.z, acceleration * delta)
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = -0.05

	move_and_slide()
	_apply_touch_look(delta)
	_apply_gyro(delta)

func _apply_look(delta_pixels: Vector2) -> void:
	rotate_y(-delta_pixels.x)
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x - delta_pixels.y, min_pitch, max_pitch)

func _apply_touch_look(delta: float) -> void:
	var look: Vector2 = InputManager.get_touch_look()
	if look.length() < 0.001:
		return
	rotate_y(-look.x * touch_look_speed * delta)
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x - look.y * touch_look_speed * delta, min_pitch, max_pitch)

func _apply_gyro(delta: float) -> void:
	var gyro: Vector3 = InputManager.get_gyro_rotation()
	if gyro.length() < 0.001:
		return
	rotate_y(-gyro.y * delta * 0.6)
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x - gyro.x * delta * 0.6, min_pitch, max_pitch)
