extends Control

@export_enum("move", "look") var control_mode := "move"
@export var radius := 82.0
@export var dead_zone := 0.05

@onready var knob: Control = $Knob

var active_index := -1
var origin := Vector2.ZERO

func _ready() -> void:
	origin = size * 0.5
	knob.position = origin - knob.size * 0.5

func _exit_tree() -> void:
	_set_value(Vector2.ZERO)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and active_index == -1:
			active_index = event.index
			_update_drag(event.position)
		elif not event.pressed and event.index == active_index:
			active_index = -1
			_set_value(Vector2.ZERO)
			knob.position = origin - knob.size * 0.5
	if event is InputEventScreenDrag and event.index == active_index:
		_update_drag(event.position)

func _update_drag(position: Vector2) -> void:
	var delta := (position - origin).limit_length(radius)
	knob.position = origin + delta - knob.size * 0.5
	var value := Vector2(delta.x / radius, delta.y / radius)
	if value.length() < dead_zone:
		value = Vector2.ZERO
	_set_value(value)

func _set_value(value: Vector2) -> void:
	if control_mode == "look":
		InputManager.set_touch_look(value)
	else:
		InputManager.set_touch_move(value)
