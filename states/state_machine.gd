class_name StateMachine

enum State {
	IDLE, MOVING, JUMPING, FALLING
}

var state_equivalence

func _init() -> void:
	state_equivalence = {
		State.IDLE : IdleState,
		State.MOVING: WalkState,
		State.JUMPING: IdleState,
		State.FALLING: IdleState,
	}

func get_state(state: State):
	if state_equivalence.has(state):
		return state_equivalence.get(state)
	else:
		printerr("No state ", str(state), " in state machine")
		#return null
