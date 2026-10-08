extends Node2D

@onready var respawn_target: SafeZone

signal safe_zone_granted(target: SafeZone)

func _on_player_safe_zone_requested() -> void:
	if not respawn_target:
		printerr("No respawn target found?")
		return

	safe_zone_granted.emit(respawn_target)

func _on_level_handler_respawn_target_changed(target: SafeZone) -> void:
	respawn_target = target
