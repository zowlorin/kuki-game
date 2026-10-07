extends State

class_name PlayerDash

@export var particle_gravity: float = 980.0
@export var emission_offset := Vector2(0, -12)
@export var fx_offset := Vector2(-22, -15)

@onready var true_fx_offset : Vector2

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()
@onready var input_listener: InputListener = owner.get_node("InputListener")

func enter() -> void:
	if player.is_on_floor():
		true_fx_offset = Vector2(player.prev_direction * fx_offset.x, fx_offset.y)
		player.helpers.get_node("LandDashFX").flip_h = player.prev_direction < 0
		player.helpers.get_node("LandDashFX").global_position = player.global_position + true_fx_offset
		player.helpers.get_node("LandDashFX").play("engage")
		player.get_node("AnimatedSprite2D").play("dash")
	else:
		player.helpers.get_node("DashParticles").global_position = player.global_position + emission_offset
		player.helpers.get_node("DashParticles").emitting = true
		player.get_node("AnimatedSprite2D").play("air_dash")
	player.dash_frame = Time.get_unix_time_from_system()

func exit() -> void:
	player.velocity.x = 0
	player.helpers.get_node("DashParticles").emitting = false

func physics_update(_delta: float) -> void:
	var curr_frame = Time.get_unix_time_from_system()
	var bouncy_nodes = get_tree().get_nodes_in_group("Bouncy")
	
	player.get_node("Hurtbox").get_child(0).set_deferred("disabled", true)
	player.velocity.x = player.prev_direction * player.dash_speed
	
	player.helpers.get_node("DashCooldown").wait_time = player.max_dash_cooldown/8
	if not player.is_on_floor():
		player.helpers.get_node("DashParticles").gravity.x = -player.prev_direction * particle_gravity
		player.helpers.get_node("DashParticles").global_position = player.global_position + emission_offset
		player.helpers.get_node("DashCooldown").wait_time = player.max_dash_cooldown
	
	player.helpers.get_node("DashInvinciblity").start()
	player.can_dash = false
	
	if player.get_last_slide_collision() != null:
		if bouncy_nodes.has(player.get_last_slide_collision().get_collider()):
			state_machine.transition_to("Bounce")
	
	if (curr_frame - player.dash_frame) >= player.dash_duration:
		state_machine.transition_to("Fall")
	
	player.fall_frame = player.dash_frame
	player.velocity.y = (1 - (player.fall_curve.sample((curr_frame - player.dash_frame) / player.fall_duration))) * player.fall_speed
