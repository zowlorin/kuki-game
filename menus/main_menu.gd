extends Node2D

func _ready() -> void:
	AudioManager.play("TitleMusic")

func _on_button_pressed() -> void:
	AudioManager.play("StartSFX")
	AudioManager.fade_out("TitleMusic")
	get_tree().change_scene_to_file("res://main.tscn")
