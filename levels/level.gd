extends Node2D

class_name Level

signal level_change_requested(scene_path: String)

func _on_portal_handler_level_change_requested(scene_path: String) -> void:
	level_change_requested.emit(scene_path)
