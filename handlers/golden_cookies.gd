extends Node2D

signal cookie_collected(id: int)

func on_cookie_collected(id: int):
	cookie_collected.emit(id)

func _ready() -> void:
	for child in get_children():
		if (child is not GoldenCookie):
			continue
		child.connect("collected",on_cookie_collected)
