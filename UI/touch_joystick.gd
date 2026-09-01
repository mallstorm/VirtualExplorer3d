extends Control

@export var radius := 82.0

@onready var knob: ColorRect = $Knob

var active_index := -1
var origin := Vector2.ZERO

func _ready() -> void:
	origin = size * 0.5
	knob.position = origin - knob.size * 0.5

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and active_index == -1:
			active_index = event.index
			_update_drag(event.position)
		elif not event.pressed and event.index == active_index:
			active_index = -1
			InputManager.set_touch_move(Vector2.ZERO)
			knob.position = origin - knob.size * 0.5
	if event is InputEventScreenDrag and event.index == active_index:
		_update_drag(event.position)

func _update_drag(position: Vector2) -> void:
	var delta := (position - origin).limit_length(radius)
	knob.position = origin + delta - knob.size * 0.5
	InputManager.set_touch_move(Vector2(delta.x / radius, delta.y / radius))

