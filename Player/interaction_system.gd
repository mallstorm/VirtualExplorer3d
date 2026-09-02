extends RayCast3D

signal focus_changed(data: Dictionary)
signal interaction_requested(data: Dictionary)

var current_data := {}
var current_collider: Object = null

func _ready() -> void:
	enabled = true
	target_position = Vector3(0, 0, -4.0)

func _physics_process(_delta: float) -> void:
	force_raycast_update()
	var collider: Object = _read_target()
	var data: Dictionary = _read_target_data(collider)
	if data != current_data:
		_update_focus(collider)
		current_data = data
		focus_changed.emit(current_data)
	if (Input.is_action_just_pressed("interact") or InputManager.consume_touch_interact()) and not current_data.is_empty():
		if current_collider and current_collider.has_method("mark_inspected"):
			current_collider.mark_inspected()
			current_data["inspected"] = true
		interaction_requested.emit(current_data)

func _read_target() -> Object:
	if not is_colliding():
		return null
	return get_collider()

func _read_target_data(collider: Object) -> Dictionary:
	if collider and collider.has_method("get_interaction_data"):
		return collider.get_interaction_data()
	return {}

func _update_focus(collider: Object) -> void:
	if current_collider and current_collider.has_method("set_focus"):
		current_collider.set_focus(false)
	current_collider = collider
	if current_collider and current_collider.has_method("set_focus"):
		current_collider.set_focus(true)
