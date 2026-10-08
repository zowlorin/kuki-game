extends State

class_name PlayerPush

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()
@onready var input_listener: InputListener = owner.get_node("InputListener")

@onready var push_collision : KinematicCollision2D
@onready var move_direction: float = 0

@onready var input_frozen: bool = false

func enter() -> void:
	push_collision = player.get_last_slide_collision()
	
	player.get_node("AnimatedSprite2D").play("push")
	
	move_direction = Input.get_axis("move_left", "move_right")
	
	if (input_frozen):
		move_direction = 0
		
	if abs(move_direction) <= 0:
		player.accel_frame = Time.get_unix_time_from_system()

func exit() -> void:
	player.velocity.x = 0

func physics_update(_delta: float) -> void:
	var curr_frame = Time.get_unix_time_from_system()
	var bouncy_nodes = get_tree().get_nodes_in_group("Bouncy")
	
	move_direction = Input.get_axis("move_left", "move_right")
	
	if (input_frozen):
		move_direction = 0
	
	player.velocity.x = move_direction * player.accel_curve.sample((curr_frame - player.accel_frame) / player.accel_duration) * player.max_speed
	if push_collision.get_collider() is RigidBody2D:
		push_collision.get_collider().apply_central_impulse(-push_collision.get_normal() * player.push_force)
	elif not player.is_on_wall():
		state_machine.transition_to("Walk")
	
	if player.get_last_slide_collision() != null:
		if bouncy_nodes.has(player.get_last_slide_collision().get_collider()):
			state_machine.transition_to("Bounce")
	
	if (player.is_on_floor() or player.on_coyote) and not input_frozen and (Input.is_action_just_pressed("jump") or input_listener.get_buffer("JumpBuffer").is_buffered()):
		input_listener.get_buffer("JumpBuffer").consume()
		
		state_machine.transition_to("Jump")
	elif player.can_dash and not input_frozen and (Input.is_action_just_pressed("dash") or input_listener.get_buffer("DashBuffer").is_buffered()):
		input_listener.get_buffer("DashBuffer").consume()
		state_machine.transition_to("Dash")
	elif not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif abs(move_direction) == 0:
		state_machine.transition_to("Idle")

func update(_delta: float) -> void:
	player.get_node("AnimatedSprite2D").flip_h = move_direction < 0

func _on_player_input_freezed(active: bool) -> void:
	input_frozen = active
