extends Node2D

signal time_changed(value: float)
signal run_timed(value: float)

@onready var start_time = Time.get_unix_time_from_system()

@onready var current_time: float = 0:
	set(x):
		current_time = x
		time_changed.emit(x)
		
@onready var final_time: float = 0

@onready var time_guaranteed: float = 0

@onready var updating: bool = true

@onready var paused: bool = false

func _process(delta: float) -> void:
	if (!updating):
		return
	if (paused):
		current_time = time_guaranteed
		return
	current_time = time_guaranteed + Time.get_unix_time_from_system() - start_time

func _on_game_handler_game_end() -> void:
	final_time = current_time
	updating = false
	run_timed.emit(final_time)

func _on_game_handler_pause_state_changed(active: bool) -> void:
	paused = active
	if (active):
		time_guaranteed += Time.get_unix_time_from_system() - start_time
	else:
		start_time = Time.get_unix_time_from_system()
