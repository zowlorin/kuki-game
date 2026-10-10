extends State

class_name PlayerThrow

signal projectile_requested

@onready var player: Player = owner
@onready var state_machine: StateMachine = get_parent()
@onready var input_listener: InputListener = owner.get_node("InputListener")

@onready var input_frozen: bool = false

@onready var player_cap: PlayerCap = owner.get_node("PlayerCap")
@onready var player_cap_origin: Node2D = owner.get_node("Helpers/CapOrigin")

@onready var velocity_snapshot: Vector2 = Vector2.ZERO

func enter() -> void:
	player.throw_frame = Time.get_unix_time_from_system()
	
	player.get_node("AnimatedSprite2D").play("throw")
	
	player_cap.throw(player_cap_origin.global_position, player.prev_direction)
	
	player.can_throw = false
	
	AudioManager.play("ThrowSFX")
	
	velocity_snapshot = player.velocity
	player.velocity = Vector2.ZERO

func exit() -> void:
	player.velocity = velocity_snapshot

func physics_update(_delta: float) -> void:
	var curr_frame = Time.get_unix_time_from_system()
	var bouncy_nodes = get_tree().get_nodes_in_group("Bouncy")
	
	player.get_node("Hurtbox").get_child(0).set_deferred("disabled", true)
	
	if player.can_dash and not input_frozen and (Input.is_action_just_pressed("dash") or input_listener.get_buffer("DashBuffer").is_buffered()):
		input_listener.get_buffer("DashBuffer").consume()
		state_machine.transition_to("Dash")
		
	elif (player.is_on_floor() or player.on_coyote) and not input_frozen and (Input.is_action_just_pressed("jump") or input_listener.get_buffer("JumpBuffer").is_buffered()):
		input_listener.get_buffer("JumpBuffer").consume()
		
		state_machine.transition_to("Jump")
	
	elif (curr_frame - player.throw_frame) >= player.throw_duration:
		state_machine.transition_to("Idle")

func _on_player_input_freezed(active: bool) -> void:
	input_frozen = active
