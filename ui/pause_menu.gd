extends Control

signal game_resume_requested
signal game_quit_requested
signal settings_requested

signal menu_focused(active: bool)

func _ready():
	visible = false

func _on_resume_button_pressed() -> void:
	game_resume_requested.emit()
	menu_focused.emit(false)

func _on_settings_button_pressed() -> void:
	AudioManager.play("ClickSFX")
	settings_requested.emit()
	menu_focused.emit(false)

func _on_exit_button_pressed() -> void:
	AudioManager.play("ClickSFX")
	game_quit_requested.emit()
	menu_focused.emit(false)

func _on_game_handler_pause_state_changed(active: bool) -> void:
	visible = active
	AudioManager.play("PauseSFX")
	menu_focused.emit(active)

func _on_settings_menu_exit_requested() -> void:
	visible = true
	await get_tree().process_frame
	menu_focused.emit(true)
