extends State

class_name PlayerFall

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()
@onready var input_listener: InputListener = owner.get_node("InputListener")
@onready var sprite: AnimatedSprite2D = player.get_node("AnimatedSprite2D")

@onready var bouncing: bool = false

@onready var input_frozen: bool = false

func enter() -> void:
	sprite.play("fall")
	player.fall_frame = Time.get_unix_time_from_system()
	bouncing = false

func physics_update(_delta: float) -> void:
	var move_direction = Input.get_axis("move_left", "move_right")
	var bouncy_nodes = get_tree().get_nodes_in_group("Bouncy")
	
	if player.get_last_slide_collision() != null:
		if bouncy_nodes.has(player.get_last_slide_collision().get_collider()):
			bouncing = true
			state_machine.transition_to("Bounce")
	if player.is_on_floor() and player.get_platform_velocity() != Vector2.ZERO:
		emit_land_particles()
		state_machine.transition_to("Idle")
	elif player.is_on_floor() and not bouncing:
		emit_land_particles()
		state_machine.transition_to("Stagger")
	elif player.is_on_floor() and not input_frozen and (abs(Input.get_axis("move_left", "move_right")) > 0 or input_listener.get_buffer("MoveLeftBuffer").is_buffered() or input_listener.get_buffer("MoveRightBuffer").is_buffered()):
		input_listener.get_buffer("MoveLeftBuffer").consume()
		input_listener.get_buffer("MoveRightBuffer").consume()
		state_machine.transition_to("Walk")
	elif (player.is_on_floor() or player.on_coyote) and not input_frozen and (Input.is_action_just_pressed("jump") or input_listener.get_buffer("JumpBuffer").is_buffered()):
		input_listener.get_buffer("JumpBuffer").consume()
		state_machine.transition_to("Jump")
	elif player.can_dash and not input_frozen and (Input.is_action_just_pressed("dash") or input_listener.get_buffer("DashBuffer").is_buffered()):
		input_listener.get_buffer("DashBuffer").consume()
		state_machine.transition_to("Dash")
	
	var curr_frame = Time.get_unix_time_from_system()
	
	player.velocity.x = move_direction * player.accel_curve.sample((curr_frame - player.accel_frame) / player.accel_duration) * player.max_speed
	player.velocity.y = (1 - (player.fall_curve.sample((curr_frame - player.fall_frame) / player.fall_duration))) * player.fall_speed

func emit_land_particles() -> void:
	player.helpers.get_node('LLandParticles').global_position = player.global_position + Vector2(-10, 0)
	player.helpers.get_node('RLandParticles').global_position = player.global_position + Vector2(10, 0)
	player.helpers.get_node('LLandParticles').emitting = true
	player.helpers.get_node('RLandParticles').emitting = true

func update(_delta: float) -> void:
	sprite.flip_h = player.prev_direction < 0


func _on_player_input_freezed(active: bool) -> void:
	input_frozen = active
