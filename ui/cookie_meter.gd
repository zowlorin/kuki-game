extends Control

@onready var known_value: int = 0:
	set(x):
		known_value = x
		$MainLabel.text = str(known_value)

func _on_cookie_collect_handler_value_changed(x: int) -> void:
	known_value = x
