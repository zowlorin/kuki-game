extends State

class_name PlayerJump

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()
@onready var input_listener: InputListener = owner.get_node("InputListener")
@onready var sprite : AnimatedSprite2D = player.get_node("AnimatedSprite2D")

func enter() -> void:
	sprite.play("jump")
	player.jump_frame = Time.get_unix_time_from_system()

func exit() -> void:
	player.velocity = Vector2.ZERO

func physics_update(_delta: float) -> void:
	var curr_frame = Time.get_unix_time_from_system()
	var move_direction = Input.get_axis("move_left", "move_right")
	var bouncy_nodes = get_tree().get_nodes_in_group("Bouncy")
	
	player.velocity.y = -(player.jump_curve.sample((curr_frame - player.jump_frame) / player.jump_duration)) * player.jump_speed
	player.velocity.x = move_direction * player.accel_curve.sample((curr_frame - player.accel_frame) / player.accel_duration) * player.max_speed
	
	player.on_coyote = false
	player.helpers.get_node("CoyoteTimer").stop()
	
	if player.get_last_slide_collision() != null:
		if bouncy_nodes.has(player.get_last_slide_collision().get_collider()):
			state_machine.transition_to("Bounce")
	
	if player.can_dash and (Input.is_action_just_pressed("dash") or input_listener.get_buffer("DashBuffer").is_buffered()):
		input_listener.get_buffer("DashBuffer").consume()
		state_machine.transition_to("Dash")
	
	if (curr_frame - player.jump_frame) >= player.jump_duration or Input.is_action_just_released("jump"):
		state_machine.transition_to("Fall")

func update(_delta: float) -> void:
	sprite.flip_h = player.prev_direction < 0
