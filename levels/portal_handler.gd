extends Node2D

signal level_change_requested(scene_path: String)

func _level_change_requested(scene_path: String):
	level_change_requested.emit(scene_path)
	
func _ready() -> void:
	for child in get_children():
		child.connect("level_change_requested",_level_change_requested)
