extends Control

func _ready() -> void:
	$AnimationPlayer.play("Gained")

func _on_player_cap_state_changed(active: bool) -> void:
	if (active):
		$AnimationPlayer.play("Lost")
	else:
		$AnimationPlayer.play("Gained")
