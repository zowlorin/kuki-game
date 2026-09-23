extends State

class_name PlayerFall

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()

func enter() -> void:
	player.get_node("AnimatedSprite2D").play("idle")
	player.fall_frame = Time.get_unix_time_from_system()

func physics_update(delta: float) -> void:
	if player.is_on_floor() and (player.move_speed > 0):
		state_machine.transition_to("Walk")
	elif (player.is_on_floor() or player.on_coyote) and Input.is_action_just_pressed("move_jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	elif player.is_on_floor():
		state_machine.transition_to("Idle")
	
	var curr_frame = Time.get_unix_time_from_system()
	
	player.velocity.y = (1 - (player.fall_curve.sample((curr_frame - player.fall_frame) / player.fall_duration))) * player.fall_speed
