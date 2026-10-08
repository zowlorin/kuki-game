extends ColorRect


func _on_player_died() -> void:
	$AnimationPlayer.play("Blackout")
