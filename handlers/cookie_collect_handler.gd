extends Node2D

signal value_changed(x: int)

@onready var collected: Array = []

@onready var cookies_collected: int = 0:
	set(x):
		if (cookies_collected == x):
			return 
		cookies_collected = x
		value_changed.emit(cookies_collected)
		


func is_collected(id: int) -> bool:
	return id in collected
	
func _on_level_handler_cookie_collected(id: int) -> void:
	if (id in collected):
		return
	collected.append(id)
	cookies_collected = len(collected)
