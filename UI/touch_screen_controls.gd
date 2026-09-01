extends Control

@export_range(0.45, 0.8, 0.01) var move_zone_ratio := 0.68
@export var move_radius := 130.0
@export var move_dead_zone := 0.04
@export var look_dead_zone := 0.02

var move_touch_index := -1
var look_touch_index := -1
var move_origin := Vector2.ZERO

func _exit_tree() -> void:
	InputManager.set_touch_move(Vector2.ZERO)
	InputManager.set_touch_look(Vector2.ZERO)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_handle_touch(event)
	elif event is InputEventScreenDrag:
		_handle_drag(event)

func _handle_touch(event: InputEventScreenTouch) -> void:
	if event.pressed:
		if _is_move_zone(event.position) and move_touch_index == -1:
			move_touch_index = event.index
			move_origin = event.position
			_update_move(event.position)
		elif look_touch_index == -1:
			look_touch_index = event.index
	else:
		if event.index == move_touch_index:
			move_touch_index = -1
			InputManager.set_touch_move(Vector2.ZERO)
		elif event.index == look_touch_index:
			look_touch_index = -1
			InputManager.set_touch_look(Vector2.ZERO)
	accept_event()

func _handle_drag(event: InputEventScreenDrag) -> void:
	if event.index == move_touch_index:
		_update_move(event.position)
		accept_event()
	elif event.index == look_touch_index:
		if event.relative.length() >= look_dead_zone:
			InputManager.add_touch_look(event.relative)
		accept_event()

func _update_move(position: Vector2) -> void:
	var delta := (position - move_origin).limit_length(move_radius)
	var value := Vector2(delta.x / move_radius, delta.y / move_radius)
	if value.length() < move_dead_zone:
		value = Vector2.ZERO
	InputManager.set_touch_move(value)

func _is_move_zone(position: Vector2) -> bool:
	var viewport_width := get_viewport_rect().size.x
	return position.x <= viewport_width * move_zone_ratio
