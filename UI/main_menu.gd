extends Control

@onready var continue_button: Button = $Panel/Margin/VBox/Continue
@onready var projects_button: Button = $Panel/Margin/VBox/Projects
@onready var settings_button: Button = $Panel/Margin/VBox/Settings
@onready var about_button: Button = $Panel/Margin/VBox/About

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_pressed)
	projects_button.pressed.connect(_on_projects_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	about_button.pressed.connect(_on_about_pressed)

func _on_continue_pressed() -> void:
	SceneManager.go_to_scene("res://Projects/Chernobyl/scenes/reactor_room.tscn", "reactor_block")

func _on_projects_pressed() -> void:
	print("Project import UI is planned. Import backend is ready through ProjectImporter.import_zip().")

func _on_settings_pressed() -> void:
	print("Settings UI is planned. Runtime input settings are ready through InputManager.")

func _on_about_pressed() -> void:
	print("Virtual Explorer - Godot 4 mobile virtual exploration engine.")

