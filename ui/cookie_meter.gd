extends Control

@onready var known_value: int = 0:
	set(x):
		known_value = x
		$Sprite2D.frame = 6 - x

func _on_cookie_collect_handler_value_changed(x: int) -> void:
	if known_value < x:
		AudioManager.play("CollectSFX")
	$AnimationPlayer.play("Gained")
	known_value = x
