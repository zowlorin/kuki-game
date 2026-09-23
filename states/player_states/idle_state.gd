extends State

class_name PlayerIdle

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()

func enter() -> void:
	player.get_node("AnimatedSprite2D").play("idle")
	player.decel_frame = Time.get_unix_time_from_system()

func physics_update(delta: float) -> void:
	var curr_frame = Time.get_unix_time_from_system()
	var move_direction = Input.get_axis("move_left", "move_right")
	
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	if (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) and move_direction != 0	:
		state_machine.transition_to("Walk")
	elif Input.is_action_just_pressed("move_jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	
	player.velocity.y = (1 - (player.fall_curve.sample((curr_frame - player.fall_frame) / player.fall_duration))) * player.fall_speed
