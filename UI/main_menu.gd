extends Control

@onready var continue_button: Button = $Panel/Margin/VBox/Continue
@onready var projects_button: Button = $Panel/Margin/VBox/Projects
@onready var settings_button: Button = $Panel/Margin/VBox/Settings
@onready var about_button: Button = $Panel/Margin/VBox/About
@onready var info_label: Label = $Panel/Margin/VBox/Info

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_pressed)
	projects_button.pressed.connect(_on_projects_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	about_button.pressed.connect(_on_about_pressed)
	info_label.text = "Демо-проект: Chernobyl Sarcophagus Experience"

func _on_continue_pressed() -> void:
	SceneManager.go_to_scene("res://Projects/Chernobyl/scenes/reactor_room.tscn", "reactor_block")

func _on_projects_pressed() -> void:
	info_label.text = "Доступен демо-проект Chernobyl. Импорт ZIP уже есть в ядре и будет вынесен в Android file picker следующим этапом."

func _on_settings_pressed() -> void:
	info_label.text = "Управление: левая часть экрана - движение, правая - обзор. Гироскоп можно включить в игровом меню."

func _on_about_pressed() -> void:
	info_label.text = "Virtual Explorer - мобильный движок виртуальных экскурсий на Godot 4."
