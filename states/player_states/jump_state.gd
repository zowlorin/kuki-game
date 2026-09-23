extends State

class_name PlayerJump

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()

func enter() -> void:
	player.get_node("AnimatedSprite2D").play("idle")
	player.jump_frame = Time.get_unix_time_from_system()

func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	elif player.is_on_floor() and (Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right")):
		state_machine.transition_to("Walk")
	
	var curr_frame = Time.get_unix_time_from_system()
	
	if (curr_frame - player.jump_frame) >= player.jump_duration or Input.is_action_just_released("move_jump"):
		state_machine.transition_to("Fall")
	
	player.velocity.y = -(player.jump_curve.sample((curr_frame - player.jump_frame) / player.jump_duration)) * player.jump_speed
	
	player.on_coyote = false
	player.helpers.get_node("CoyoteTimer").stop()
