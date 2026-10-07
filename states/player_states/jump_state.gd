extends State

class_name PlayerJump

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()
@onready var input_listener: InputListener = owner.get_node("InputListener")
@onready var sprite : AnimatedSprite2D = player.get_node("AnimatedSprite2D")

func enter() -> void:
	sprite.play("jump")
	AudioManager.play("JumpSFX")
	player.jump_frame = Time.get_unix_time_from_system()

func exit() -> void:
	player.velocity.y = 0

func physics_update(_delta: float) -> void:
	if player.can_dash and (Input.is_action_just_pressed("dash") or input_listener.get_buffer("DashBuffer").is_buffered()):
		input_listener.get_buffer("DashBuffer").consume()
		state_machine.transition_to("Dash")
	
	var curr_frame = Time.get_unix_time_from_system()
	
	if (curr_frame - player.jump_frame) >= player.jump_duration or Input.is_action_just_released("jump"):
		state_machine.transition_to("Fall")
	
	player.velocity.y = -(player.jump_curve.sample((curr_frame - player.jump_frame) / player.jump_duration)) * player.jump_speed
	player.move_speed = player.accel_curve.sample((curr_frame - player.accel_frame) / player.accel_duration) * player.max_speed
	
	player.on_coyote = false
	player.helpers.get_node("CoyoteTimer").stop()

func update(_delta: float) -> void:
	sprite.flip_h = player.prev_direction < 0
