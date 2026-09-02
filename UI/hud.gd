extends CanvasLayer

@onready var hint_label: Label = $Root/Hint
@onready var info_panel: PanelContainer = $Root/InformationPanel
@onready var info_title: Label = $Root/InformationPanel/Margin/VBox/Title
@onready var info_body: Label = $Root/InformationPanel/Margin/VBox/Body
@onready var touch_controls: Control = $Root/TouchScreenControls
@onready var zone_label: Label = $Root/ZoneLabel
@onready var objective_label: Label = $Root/ObjectiveLabel
@onready var action_button: Button = $Root/ActionButton
@onready var journal_button: Button = $Root/JournalButton
@onready var menu_button: Button = $Root/MenuButton
@onready var pause_panel: PanelContainer = $Root/PausePanel
@onready var resume_button: Button = $Root/PausePanel/Margin/VBox/Resume
@onready var panorama_button: Button = $Root/PausePanel/Margin/VBox/Panorama
@onready var restart_button: Button = $Root/PausePanel/Margin/VBox/Restart
@onready var gyro_button: Button = $Root/PausePanel/Margin/VBox/Gyro
@onready var close_menu_button: Button = $Root/PausePanel/Margin/VBox/CloseMenu

var player: Node = null

func _ready() -> void:
	info_panel.visible = false
	pause_panel.visible = false
	action_button.pressed.connect(_on_action_pressed)
	journal_button.pressed.connect(_on_journal_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	resume_button.pressed.connect(_on_resume_pressed)
	panorama_button.pressed.connect(_on_panorama_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	gyro_button.pressed.connect(_on_gyro_pressed)
	close_menu_button.pressed.connect(_on_resume_pressed)
	SaveManager.load_state()
	_connect_player.call_deferred()

func _process(_delta: float) -> void:
	if OS.get_name() != "Android":
		touch_controls.visible = false
		action_button.visible = false
	if Input.is_action_just_pressed("toggle_menu") or Input.is_action_just_pressed("ui_cancel"):
		_toggle_pause_panel()
	_update_route_labels()

func _connect_player() -> void:
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		player = get_tree().root.find_child("Player", true, false)
	if player == null:
		return
	var ray := player.find_child("InteractionRay", true, false)
	if ray:
		ray.focus_changed.connect(_on_focus_changed)
		ray.interaction_requested.connect(_on_interaction_requested)

func _on_focus_changed(data: Dictionary) -> void:
	if data.is_empty():
		hint_label.text = ""
		action_button.disabled = true
		action_button.visible = OS.get_name() == "Android"
		return
	hint_label.text = "%s" % data.get("name", "Объект")
	action_button.disabled = false
	action_button.visible = true

func _on_interaction_requested(data: Dictionary) -> void:
	SaveManager.add_journal_entry(data)
	var journal_count: int = SaveManager.get_journal().size()
	journal_button.text = "Журнал %d" % journal_count
	info_title.text = data.get("name", "Информация")
	info_body.text = data.get("description", "")
	info_panel.visible = true
	var audio_path: String = str(data.get("audio", ""))
	if not audio_path.is_empty():
		AudioManager.play_narration(audio_path)

func _on_close_pressed() -> void:
	info_panel.visible = false

func _on_action_pressed() -> void:
	InputManager.request_touch_interact()

func _on_journal_pressed() -> void:
	var entries: Array = SaveManager.get_journal()
	info_title.text = "Журнал осмотра"
	if entries.is_empty():
		info_body.text = "Пока нет открытых объектов. Наведи прицел на подсвеченный объект и нажми «Действие»."
	else:
		var lines := PackedStringArray()
		for item in entries:
			if item is Dictionary:
				lines.append("- %s\n%s" % [str(item.get("name", "Объект")), str(item.get("description", ""))])
		info_body.text = "\n\n".join(lines)
	info_panel.visible = true

func _on_menu_pressed() -> void:
	_toggle_pause_panel()

func _on_resume_pressed() -> void:
	pause_panel.visible = false

func _on_panorama_pressed() -> void:
	SceneManager.open_panorama("res://Projects/Chernobyl/panoramas/reactor_placeholder_360.jpg")

func _on_restart_pressed() -> void:
	SaveManager.clear_journal()
	SceneManager.go_to_scene("res://Projects/Chernobyl/scenes/reactor_room.tscn", "reactor_block")

func _on_gyro_pressed() -> void:
	InputManager.set_gyro_enabled(not InputManager.gyro_enabled)
	gyro_button.text = "Гироскоп: %s" % ("вкл" if InputManager.gyro_enabled else "выкл")

func _toggle_pause_panel() -> void:
	pause_panel.visible = not pause_panel.visible

func _update_route_labels() -> void:
	if player == null:
		return
	var position: Vector3 = player.global_position
	var zone: String = _zone_name_from_position(position)
	zone_label.text = zone
	objective_label.text = _objective_for_zone(zone)

func _zone_name_from_position(position: Vector3) -> String:
	if position.z > 8.0:
		return "Входной тоннель"
	if position.x < -6.0:
		return "Пультовая"
	if position.x > 6.0:
		return "Технический коридор"
	if position.z < -1.0:
		return "Реакторный блок"
	return "Центральный зал"

func _objective_for_zone(zone: String) -> String:
	match zone:
		"Входной тоннель":
			return "Цель: пройти к центральному залу"
		"Центральный зал":
			return "Цель: осмотреть реакторный блок"
		"Реакторный блок":
			return "Цель: найти пультовую и 360-портал"
		"Пультовая":
			return "Цель: осмотреть пульт управления"
		"Технический коридор":
			return "Цель: проверить аварийную дверь"
	return ""
