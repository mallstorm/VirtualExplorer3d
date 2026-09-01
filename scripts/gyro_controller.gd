extends Node

var enabled := false

func enable() -> void:
	enabled = true
	InputManager.set_gyro_enabled(true)

func disable() -> void:
	enabled = false
	InputManager.set_gyro_enabled(false)

func get_sensor_rotation() -> Vector3:
	if enabled:
		return InputManager.get_gyro_rotation()
	return Vector3.ZERO
