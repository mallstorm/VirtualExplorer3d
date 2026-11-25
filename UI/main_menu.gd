extends Control

@onready var continue_button: Button = $Panel/Margin/VBox/Continue
@onready var projects_button: Button = $Panel/Margin/VBox/Projects
@onready var import_button: Button = $Panel/Margin/VBox/ImportZip
@onready var settings_button: Button = $Panel/Margin/VBox/Settings
@onready var about_button: Button = $Panel/Margin/VBox/About
@onready var selected_label: Label = $Panel/Margin/VBox/Selected
@onready var info_label: Label = $Panel/Margin/VBox/Info

var project_paths: Array[String] = []
var selected_index := 0

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_pressed)
	projects_button.pressed.connect(_on_projects_pressed)
	import_button.pressed.connect(_on_import_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	about_button.pressed.connect(_on_about_pressed)
	$Panel/Margin/VBox/PanoramaDemo.pressed.connect(_on_panorama_demo_pressed)
	_refresh_projects()

func _on_panorama_demo_pressed() -> void:
	var result := get_tree().change_scene_to_file("res://Renderer/PanoramaRenderer/mountain_lake_demo.tscn")
	if result != OK:
		info_label.text = "Не удалось открыть встроенную панораму."

func _refresh_projects() -> void:
	SaveManager.load_state()
	project_paths = ProjectImporter.list_imported_projects()
	if project_paths.is_empty():
		selected_label.text = "Проекты не установлены"
		info_label.text = "Скачай ZIP экскурсии и положи его в Download. Затем нажми «Импорт ZIP» в настройках."
		continue_button.disabled = true
		projects_button.disabled = true
		return
	var saved_project: String = SaveManager.get_selected_project()
	var saved_index: int = project_paths.find(saved_project)
	if saved_index >= 0:
		selected_index = saved_index
	selected_index = clampi(selected_index, 0, project_paths.size() - 1)
	SaveManager.set_selected_project(project_paths[selected_index])
	continue_button.disabled = false
	projects_button.disabled = false
	_update_selected_text()

func _update_selected_text() -> void:
	var summary: Dictionary = ProjectImporter.get_project_summary(project_paths[selected_index])
	selected_label.text = "Выбрано: %s" % str(summary.get("name", "Без названия"))
	info_label.text = "Версия пакета: %s\nФайл: %s" % [str(summary.get("version", "")), project_paths[selected_index]]

func _on_continue_pressed() -> void:
	if project_paths.is_empty():
		info_label.text = "Сначала импортируй ZIP-проект."
		return
	SceneManager.start_project(project_paths[selected_index])

func _on_projects_pressed() -> void:
	if project_paths.is_empty():
		_refresh_projects()
		return
	selected_index = (selected_index + 1) % project_paths.size()
	SaveManager.set_selected_project(project_paths[selected_index])
	_update_selected_text()

func _on_import_pressed() -> void:
	var imported: String = ProjectImporter.import_first_available_zip()
	if imported.is_empty():
		info_label.text = "ZIP не найден. Ожидаемый файл: Download/Chernobyl_Sarcophagus_Experience.zip"
		return
	info_label.text = "Проект импортирован: %s" % imported
	_refresh_projects()

func _on_settings_pressed() -> void:
	info_label.text = "Настройки проекта:\n1. Импорт ZIP из Download.\n2. «Следующий проект» выбирает установленную экскурсию.\n3. «Запустить выбранный проект» применяет пакет.\nПортретный режим отключён."

func _on_about_pressed() -> void:
	info_label.text = "Virtual Explorer — плеер виртуальных экскурсий на Godot 4. Экскурсии устанавливаются отдельными ZIP-пакетами."
