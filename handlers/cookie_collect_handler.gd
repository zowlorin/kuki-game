extends Node2D

signal value_changed(x: int)
signal necessary_cookies_collected

@onready var collected: Array = []

@onready var cookies_collected: int = 0:
	set(x):
		if (cookies_collected == x):
			return 
		cookies_collected = x
		value_changed.emit(cookies_collected)
		
@onready var cookies_fed: int = 0

@export var cookies_needed: int = 1

func can_feed_cookies() -> bool:
	return cookies_collected > 0
	
func on_cookie_fed():
	if not can_feed_cookies():
		return
	cookies_fed += 1
	cookies_collected -= 1
	
	if (cookies_fed >= cookies_needed):
		necessary_cookies_collected.emit()

func is_collected(id: int) -> bool:
	return id in collected
	
func _on_level_handler_cookie_collected(id: int) -> void:
	if (id in collected):
		return
	collected.append(id)
	cookies_collected = len(collected)
