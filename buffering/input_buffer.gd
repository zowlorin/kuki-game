extends Node

class_name InputBuffer

@export var action_name : StringName = &""
@export var buffer_time : float = 0.3

@onready var _buffer_timer: float

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(action_name):
		_buffer_timer = buffer_time

func _physics_process(delta: float) -> void:
	if _buffer_timer > 0.0:
		_buffer_timer -= delta

func is_buffered() -> bool:
	return _buffer_timer > 0.0

func consume():
	_buffer_timer = 0.0
