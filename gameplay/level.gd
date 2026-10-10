extends Node2D

class_name Level

signal level_change_requested(scene_path: String, target_id: String)
signal respawn_target_changed(target: SafeZone)
signal cookie_collected(id: int)

func _on_portal_handler_level_change_requested(scene_path: String, target_id: String) -> void:
	level_change_requested.emit(scene_path, target_id)

func _on_safe_zones_zone_changed(zone: SafeZone) -> void:
	await get_tree().process_frame
	respawn_target_changed.emit(zone)

func _on_golden_cookies_cookie_collected(id: int) -> void:
	cookie_collected.emit(id)
