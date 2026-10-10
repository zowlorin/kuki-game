extends ColorRect

func _ready() -> void:
	visible = false

func _on_player_died() -> void:
	print("ogei")
	$AnimationPlayer.play("Blackout")
