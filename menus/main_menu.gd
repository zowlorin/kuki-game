extends Node2D

func _ready() -> void:
	AudioManager.fade_out("GameMusic", 1.0)
	AudioManager.play("TitleMusic")

func _on_button_pressed() -> void:
	AudioManager.play("StartSFX")
	AudioManager.fade_out("TitleMusic", 2.0)
	get_tree().change_scene_to_file("res://main.tscn")
