extends Node2D

signal value_changed(x: int)
signal necessary_cookies_collected

@onready var collected: Array = []
@onready var fed: Array = []

@onready var cookies_collected: int = 0:
	set(x):
		if (cookies_collected == x):
			return 
		cookies_collected = x
		value_changed.emit(cookies_collected)
		
@onready var cookies_fed: int = 0

@export var cookies_needed: int = 2

func can_feed_cookies() -> bool:
	return cookies_collected > 0
	
func on_cookie_fed():
	if not can_feed_cookies():
		return
	
	for cookie in collected:
		if cookie in fed:
			continue
		fed.append(cookie)
	
	cookies_fed = fed.size()
	cookies_collected = collected.size() - fed.size()
	
	if (cookies_fed >= cookies_needed):
		necessary_cookies_collected.emit()

func is_collected(id: int) -> bool:
	return id in collected

func is_fed(id: int) -> bool:
	return id in fed
	
func _on_level_handler_cookie_collected(id: int) -> void:
	if is_collected(id):
		return
	collected.append(id)
	cookies_collected = collected.size() - fed.size()

func _on_level_handler_cookie_dropped(id: int) -> void:
	if not is_collected(id):
		return
	if is_fed(id):
		return
	
	collected.erase(id)
	cookies_collected = collected.size() - fed.size()
