extends State

class_name PlayerWalk

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()
@onready var input_listener: InputListener = owner.get_node("InputListener")

@onready var move_direction: float = 0

func enter() -> void:
	player.get_node("AnimatedSprite2D").play("walk")
	
	move_direction = Input.get_axis("move_left", "move_right")
	if abs(move_direction) <= 0:
		player.accel_frame = Time.get_unix_time_from_system()

func exit() -> void:
	player.velocity.x = 0

func physics_update(_delta: float) -> void:
	var curr_frame = Time.get_unix_time_from_system()
	var bouncy_nodes = get_tree().get_nodes_in_group("Bouncy")
	move_direction = Input.get_axis("move_left", "move_right")
	
	player.velocity.x = move_direction * player.accel_curve.sample((curr_frame - player.accel_frame) / player.accel_duration) * player.max_speed
	
	if player.get_last_slide_collision() != null:
		if bouncy_nodes.has(player.get_last_slide_collision().get_collider()):
			state_machine.transition_to("Bounce")
	
	if (player.is_on_floor() or player.on_coyote) and (Input.is_action_just_pressed("jump") or input_listener.get_buffer("JumpBuffer").is_buffered()):
		input_listener.get_buffer("JumpBuffer").consume()
		
		state_machine.transition_to("Jump")
	elif player.can_dash and (Input.is_action_just_pressed("dash") or input_listener.get_buffer("DashBuffer").is_buffered()):
		input_listener.get_buffer("DashBuffer").consume()
		state_machine.transition_to("Dash")
	elif not player.is_on_floor():
		
		state_machine.transition_to("Fall")
	elif abs(move_direction) == 0:
		
		state_machine.transition_to("Idle")

func update(_delta: float) -> void:
	player.get_node("AnimatedSprite2D").flip_h = move_direction < 0
