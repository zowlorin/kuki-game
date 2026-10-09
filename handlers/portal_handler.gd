extends Node2D

signal level_change_requested(scene_path: String, target_id: String)

func _level_change_requested(scene_path: String, target_id: String):
	level_change_requested.emit(scene_path, target_id)
	
func _ready() -> void:
	for child in get_children():
		child.connect("level_change_requested",_level_change_requested)
