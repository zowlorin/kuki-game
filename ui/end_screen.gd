extends Control

signal main_menu_requested

func _ready() -> void:
	visible = false

func _on_return_button_pressed() -> void:
	main_menu_requested.emit()


func _on_game_handler_game_end() -> void:
	visible = true

func format_time(t):
	var min: int = floor(t / 60)
	var sec: int = int(t-min*60)
	
	return "%02d:%02d" % [min, sec]

func _on_game_timer_run_timed(value: float) -> void:
	$Time.text = format_time(value)
