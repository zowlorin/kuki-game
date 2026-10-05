extends Node

class_name InputListener

@export var general_buffer_time : float = 0.3

func _ready() -> void:
	for input in InputMap.get_actions():
		if input.contains("ui"):
			continue
		
		var new_buffer = InputBuffer.new()
		new_buffer.action_name = input
		new_buffer.buffer_time = general_buffer_time
		new_buffer.name = input.to_pascal_case() + "Buffer"
		add_child(new_buffer)

func get_buffer(buffer_name: String) -> InputBuffer:
	if not has_node(buffer_name):
		return null
	
	return get_node(buffer_name)
