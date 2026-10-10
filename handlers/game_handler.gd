extends Node2D

signal pause_state_changed(active: bool)
signal game_quit
signal game_end

@onready var paused: bool = false:
	set(x):
		if (paused == x):
			return
		paused = x
		get_tree().paused = paused
		pause_state_changed.emit(x)
		
		
@onready var running: bool = true:
	set(x):
		if (running == x):
			return
		running = x
		if (!running):
			game_quit.emit()

@onready var pause_menu_focused: bool = false

@onready var ended: bool = false

func request_main_menu():
	running = false
	paused = false
	
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
	
func request_break():
	paused = true
	
func resume_world():
	paused = false

func on_escape():
	if (!paused):
		request_break()
	else:
		if (pause_menu_focused):
			resume_world()

func _input(event: InputEvent) -> void:
	if (event is not InputEventKey):
		return
		
	if (!event.pressed):
		return
		
	if (event.keycode != KEY_ESCAPE):
		return
	
	on_escape()

func _on_pause_menu_game_resume_requested() -> void:
	resume_world()

func _on_pause_menu_game_quit_requested() -> void:
	request_main_menu()


func _on_pause_menu_menu_focused(active: bool) -> void:
	pause_menu_focused = active


func _on_end_screen_main_menu_requested() -> void:
	request_main_menu()


func _on_cookie_collect_handler_necessary_cookies_collected() -> void:
	ended = true
	game_end.emit()
	print('yeah')
