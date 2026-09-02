extends Node

const SAVE_PATH := "user://virtual_explorer_save.json"

var state := {
	"last_project": "Chernobyl",
	"last_scene": "reactor_block",
	"spawn_id": "start",
	"journal": []
}

func save_state() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(state, "\t"))

func load_state() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return state
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(SAVE_PATH))
	if typeof(parsed) == TYPE_DICTIONARY:
		state = parsed
	return state

func set_position(project_id: String, scene_id: String, spawn_id: String) -> void:
	state["last_project"] = project_id
	state["last_scene"] = scene_id
	state["spawn_id"] = spawn_id
	save_state()

func add_journal_entry(data: Dictionary) -> void:
	var object_id: String = str(data.get("id", ""))
	if object_id.is_empty():
		return
	var journal: Array = state.get("journal", [])
	for item in journal:
		if item is Dictionary and str(item.get("id", "")) == object_id:
			return
	journal.append({
		"id": object_id,
		"name": str(data.get("name", "Объект")),
		"description": str(data.get("description", ""))
	})
	state["journal"] = journal
	save_state()

func get_journal() -> Array:
	var journal: Array = state.get("journal", [])
	return journal

func clear_journal() -> void:
	state["journal"] = []
	save_state()
