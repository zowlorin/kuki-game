extends StateMachine

func _on_player_freezed(active: bool) -> void:
	frozen = active

func _on_player_died() -> void:
	return

func _on_player_respawned() -> void:
	on_start()
	
