extends Node

signal vr_mode_changed(enabled: bool)

var enabled := false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_vr"):
		set_vr_enabled(not enabled)

func set_vr_enabled(value: bool) -> void:
	enabled = value
	vr_mode_changed.emit(enabled)

func configure_camera_pair(left_camera: Camera3D, right_camera: Camera3D, eye_distance := 0.064) -> void:
	if left_camera == null or right_camera == null:
		return
	left_camera.position.x = -eye_distance * 0.5
	right_camera.position.x = eye_distance * 0.5
	left_camera.fov = 82.0
	right_camera.fov = 82.0

