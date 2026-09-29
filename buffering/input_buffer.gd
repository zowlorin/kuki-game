extends Node

class_name InputBuffer

@export var buffer_time : float = 0.3

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = player.get_node("StateMachine")

@onready var buffered: String
@onready var buffer_start: float

func _unhandled_input(event: InputEvent) -> void:
	if buffered != "":
		return
		
	if event.is_action_pressed("jump") and state_machine.current_state.name == "Fall":
		buffer_start = Time.get_unix_time_from_system()
		buffered = "jump"
		print("Buffered " + buffered)
	elif event.is_action_pressed("dash") and player.can_dash:
		buffer_start = Time.get_unix_time_from_system()
		buffered = "dash"
		print("Buffered " + buffered)

func _physics_process(delta: float) -> void:
	var curr_frame: float = Time.get_unix_time_from_system()
	
	if buffered == "":
		return
	
	if player.is_on_floor() and Input.is_action_just_pressed(buffered) and (curr_frame - buffer_start) <= buffer_time:
		print("Allowed " + buffered)
		state_machine.transition_to(buffered.capitalize())
		buffered = ""
	
	if (curr_frame - buffer_start) <= buffer_time:
		buffered = ""
