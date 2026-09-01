extends Area3D

@export var target_scene_id := ""
@export_file("*.tscn") var target_scene_path := ""
@export_file("*.jpg", "*.jpeg", "*.png") var target_panorama_path := ""

var activated := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if activated:
		return
	if not body.is_in_group("player"):
		return
	activated = true
	if not target_panorama_path.is_empty():
		SceneManager.open_panorama(target_panorama_path)
	elif not target_scene_path.is_empty():
		SceneManager.go_to_scene(target_scene_path, target_scene_id)

