extends State

class_name PlayerDash

@export var particle_gravity: float = 980.0
@export var emission_offset := Vector2(0, -12)
@export var v_emission_offset := Vector2(0, -20)
@export var fx_offset := Vector2(-22, -15)

@onready var true_fx_offset : Vector2

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()
@onready var input_listener: InputListener = owner.get_node("InputListener")

@onready var input_frozen: bool = false
@onready var true_direction: float
@onready var going_down: bool = false

func enter() -> void:
	true_direction = player.mirror_factor[int(player.mirrored)] * player.prev_direction
	player.dash_frame = Time.get_unix_time_from_system()
	
	if player.is_on_floor():
		true_fx_offset = Vector2(true_direction * fx_offset.x, fx_offset.y)
		player.helpers.get_node("LandDashFX").flip_h = true_direction < 0
		player.helpers.get_node("LandDashFX").global_position = player.global_position + true_fx_offset
		player.helpers.get_node("LandDashFX").play("engage")
		player.get_node("AnimatedSprite2D").play("dash")
	else:
		
		player.helpers.get_node("DashParticles").global_position = player.global_position + emission_offset
		player.helpers.get_node("DashParticles").emitting = true
		player.get_node("AnimatedSprite2D").play("air_dash")
	
	AudioManager.play("DashSFX")

func exit() -> void:
	player.velocity.x = 0
	player.set_collision_mask_value(2, true)
	player.set_collision_mask_value(4, true)
	player.helpers.get_node("DashParticles").emitting = false

func physics_update(_delta: float) -> void:
	var curr_frame = Time.get_unix_time_from_system()
	var bouncy_nodes = get_tree().get_nodes_in_group("Bouncy")
	
	player.set_collision_mask_value(2, false)
	player.set_collision_mask_value(4, false)
	player.get_node("Hurtbox").get_child(0).set_deferred("disabled", true)
	
	player.velocity.x = true_direction * player.dash_speed
	
	player.helpers.get_node("DashCooldown").wait_time = player.max_dash_cooldown/8
	if not player.is_on_floor():
		player.helpers.get_node("DashParticles").gravity.x = -true_direction * particle_gravity
		player.helpers.get_node("DashParticles").global_position = player.global_position + emission_offset
		player.helpers.get_node("DashCooldown").wait_time = player.max_dash_cooldown
	
	player.helpers.get_node("DashInvinciblity").start()
	player.can_dash = false
	
	if player.get_last_slide_collision() != null:
		if bouncy_nodes.has(player.get_last_slide_collision().get_collider()):
			state_machine.transition_to("Bounce")
		elif player.get_last_slide_collision().get_collider() is RigidBody2D or player.is_on_wall():
			player.get_last_slide_collision().get_collider().apply_central_impulse(2 * -player.get_last_slide_collision().get_normal() * player.push_force)
	
	if (curr_frame - player.dash_frame) >= player.dash_duration:
		state_machine.transition_to("Fall")
	
	player.fall_frame = player.dash_frame
	player.velocity.y = (1 - (player.fall_curve.sample((curr_frame - player.dash_frame) / player.fall_duration))) * player.fall_speed

func _on_player_input_freezed(active: bool) -> void:
	input_frozen = active
