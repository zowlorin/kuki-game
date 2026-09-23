extends State

class_name PlayerDash

@export var particle_gravity: float = 980.0
@export var emission_offset := Vector2(0, -12)

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()

func enter() -> void:
	if not player.can_dash:
		state_machine.transition_to(state_machine.prev_state.name)
		return
	
	player.helpers.get_node("DashParticles").global_position = player.global_position + emission_offset
	player.helpers.get_node("DashParticles").emitting = true
	
	player.get_node("AnimatedSprite2D").play("dash")
	player.dash_frame = Time.get_unix_time_from_system()

func exit() -> void:
	player.helpers.get_node("DashParticles").emitting = false

func physics_update(_delta: float) -> void:
	var curr_frame = Time.get_unix_time_from_system()
	
	player.get_node("Hurtbox").get_child(0).set_deferred("disabled", true)
	player.move_dash = player.prev_direction * player.dash_speed
	player.helpers.get_node("DashParticles").gravity.x = -player.prev_direction * particle_gravity
	player.helpers.get_node("DashParticles").global_position = player.global_position + emission_offset
	player.helpers.get_node("DashInvinciblity").start()
	player.can_dash = false
	
	if (curr_frame - player.dash_frame) >= player.dash_duration:
		state_machine.transition_to("Fall")
		player.move_dash = 0
	
	player.fall_frame = player.dash_frame
	player.velocity.y = (1 - (player.fall_curve.sample((curr_frame - player.dash_frame) / player.fall_duration))) * player.fall_speed

	
