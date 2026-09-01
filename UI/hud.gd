extends CanvasLayer

@onready var hint_label: Label = $Root/Hint
@onready var info_panel: PanelContainer = $Root/InformationPanel
@onready var info_title: Label = $Root/InformationPanel/Margin/VBox/Title
@onready var info_body: Label = $Root/InformationPanel/Margin/VBox/Body
@onready var joystick: Control = $Root/TouchJoystick

var player: Node = null

func _ready() -> void:
	info_panel.visible = false
	_connect_player.call_deferred()

func _process(_delta: float) -> void:
	if OS.get_name() != "Android":
		joystick.visible = false

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
		return
	hint_label.text = "%s  [E]" % data.get("name", "Объект")

func _on_interaction_requested(data: Dictionary) -> void:
	info_title.text = data.get("name", "Информация")
	info_body.text = data.get("description", "")
	info_panel.visible = true
	var audio_path := str(data.get("audio", ""))
	if not audio_path.is_empty():
		AudioManager.play_narration(audio_path)

func _on_close_pressed() -> void:
	info_panel.visible = false
