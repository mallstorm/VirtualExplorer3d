extends Node

const ACTION_KEYS := {
	"move_forward": [KEY_W, KEY_UP],
	"move_back": [KEY_S, KEY_DOWN],
	"move_left": [KEY_A, KEY_LEFT],
	"move_right": [KEY_D, KEY_RIGHT],
	"interact": [KEY_E, KEY_ENTER],
	"ui_cancel": [KEY_ESCAPE],
	"toggle_vr": [KEY_V],
	"toggle_gyro": [KEY_G]
}

var touch_move := Vector2.ZERO
var touch_look := Vector2.ZERO
var gyro_enabled := false

func _ready() -> void:
	_register_default_actions()

func _process(_delta: float) -> void:
	touch_look = Vector2.ZERO

func _register_default_actions() -> void:
	for action in ACTION_KEYS.keys():
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		for keycode in ACTION_KEYS[action]:
			if not _action_has_key(action, keycode):
				var event := InputEventKey.new()
				event.physical_keycode = keycode
				InputMap.action_add_event(action, event)

func _action_has_key(action: StringName, keycode: int) -> bool:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey and event.physical_keycode == keycode:
			return true
	return false

func get_move_vector() -> Vector2:
	var keyboard := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if touch_move.length() > 0.02:
		return touch_move.limit_length(1.0)
	return keyboard

func set_touch_move(value: Vector2) -> void:
	touch_move = value.limit_length(1.0)

func add_touch_look(value: Vector2) -> void:
	touch_look += value

func consume_touch_look() -> Vector2:
	var value := touch_look
	touch_look = Vector2.ZERO
	return value

func set_gyro_enabled(value: bool) -> void:
	gyro_enabled = value

func get_gyro_rotation() -> Vector3:
	if gyro_enabled:
		return Input.get_gyroscope()
	return Vector3.ZERO

