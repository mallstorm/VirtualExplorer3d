extends RayCast3D

signal focus_changed(data: Dictionary)
signal interaction_requested(data: Dictionary)

var current_data := {}

func _ready() -> void:
	enabled = true
	target_position = Vector3(0, 0, -4.0)

func _physics_process(_delta: float) -> void:
	force_raycast_update()
	var data := _read_target_data()
	if data != current_data:
		current_data = data
		focus_changed.emit(current_data)
	if Input.is_action_just_pressed("interact") and not current_data.is_empty():
		interaction_requested.emit(current_data)

func _read_target_data() -> Dictionary:
	if not is_colliding():
		return {}
	var collider := get_collider()
	if collider and collider.has_method("get_interaction_data"):
		return collider.get_interaction_data()
	return {}

