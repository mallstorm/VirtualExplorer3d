extends Area3D

@export var title := "Переход"
@export_file("*.tscn") var target_scene_path := ""
@export_file("*.jpg", "*.jpeg", "*.png") var target_panorama_path := ""

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not (body is Camera3D):
		return
	if not target_scene_path.is_empty():
		SceneManager.go_to_scene(target_scene_path)
	elif not target_panorama_path.is_empty():
		SceneManager.open_panorama(target_panorama_path)
