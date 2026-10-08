extends Node2D

class_name Level

signal level_change_requested(scene_path: String)
signal respawn_target_changed(target: SafeZone)

func _on_portal_handler_level_change_requested(scene_path: String) -> void:
	level_change_requested.emit(scene_path)

func _on_safe_zones_zone_changed(zone: SafeZone) -> void:
	await get_tree().process_frame
	respawn_target_changed.emit(zone)
