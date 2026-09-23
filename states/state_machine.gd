class_name StateMachine
extends Node
 
@export var state_limit: int = 2
@export var initial_state: State
@export var is_debugging: bool = true

var current_state: State
var prev_state: State
 
func _ready() -> void:
	# Wait for the owner (Player) to be ready
	await owner.ready
 
	if initial_state == null:
		push_error("StateMachine has no initial state assigned.")
		return
	
	if not is_debugging:
		$Label.hide()
	
	current_state = initial_state
	current_state.enter()
 
func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)
	
	$Label.global_position = owner.global_position
 
func _process(delta: float) -> void:
	current_state.update(delta)
	
	$Label.text = current_state.name
 
func transition_to(target_state_name: String) -> void:
	var target_state := get_node_or_null(target_state_name) as State
	if target_state == null:
		push_error("State '%s' not found." % target_state_name)
		return
	if target_state == current_state:
		return
	
	prev_state = current_state
	current_state.exit()
	current_state = target_state
	current_state.enter()
