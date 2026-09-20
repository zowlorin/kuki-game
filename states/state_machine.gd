class_name StateMachine

# State[n] will overtake animation precedence over State[n-1]
enum State {
	IDLE, FALLING, MOVING, JUMPING, DASHING
}

var state_equivalence

func _init() -> void:
	state_equivalence = {
		State.IDLE : IdleState,
		State.FALLING: IdleState,
		State.MOVING: WalkState,
		State.JUMPING: IdleState,
		State.DASHING: IdleState,
	}

func get_state(state: State):
	if state_equivalence.has(state):
		return state_equivalence.get(state)
	else:
		printerr("No state ", str(state), " in state machine")
