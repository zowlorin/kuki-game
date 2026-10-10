extends ColorRect

func _ready() -> void:
	visible = true

func _on_level_handler_level_okay() -> void:
	AudioManager.play("GameMusic")
	$AnimationPlayer.play("Start")
