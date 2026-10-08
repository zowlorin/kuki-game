extends Control

signal exit_requested

func _ready() -> void:
	visible = false
	
func _on_game_handler_pause_state_changed(active: bool) -> void:
	visible = false


func _on_pause_menu_settings_requested() -> void:
	visible = true
	
func on_escape():
	visible = false
	exit_requested.emit()

func _input(event: InputEvent) -> void:
	if (event is not InputEventKey):
		return
		
	if (!event.pressed):
		return
		
	if (event.keycode != KEY_ESCAPE):
		return
	
	on_escape()
