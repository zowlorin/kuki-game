extends Control

signal game_resume_requested
signal game_quit_requested

func _ready():
	visible = false

func _on_resume_button_pressed() -> void:
	game_resume_requested.emit()


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	game_quit_requested.emit()


func _on_game_handler_pause_state_changed(active: bool) -> void:
	visible = active
