extends Node2D


class_name Level

@export var title: String = "Level X"

signal level_change_requested(scene_path: String, target_id: String)
signal respawn_target_changed(target: SafeZone)
signal cookie_collected(id: int)
signal cookie_dropped(id: int)

signal camera_area_entered
signal camera_area_exited

@export var level_id: int = 0

func _ready() -> void:
	var cookies = get_node_or_null("GoldenCookies")
	if cookies == null:
		print("setup cookies!!")
		return
	
	cookie_dropped.connect(cookies.on_cookie_dropped)

func _on_portal_handler_level_change_requested(scene_path: String, target_id: String) -> void:
	level_change_requested.emit(scene_path, target_id)

func _on_safe_zones_zone_changed(zone: SafeZone) -> void:
	await get_tree().process_frame
	respawn_target_changed.emit(zone)

func _on_golden_cookies_cookie_collected(id: int) -> void:
	cookie_collected.emit(id)

func _on_player_death() -> void:
	cookie_dropped.emit(level_id)

func _on_camera_areas_player_entered(focus: Node2D) -> void:
	camera_area_entered.emit(focus)

func _on_camera_areas_player_exited(focus: Node2D) -> void:
	camera_area_exited.emit(focus)
