extends State

class_name PlayerStagger

@export var jump_delay: float = 0.1

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()
@onready var input_listener: InputListener = owner.get_node("InputListener")
@onready var sprite : AnimatedSprite2D = player.get_node("AnimatedSprite2D")

func enter() -> void:
	sprite.play("stagger")
	
	if !(sprite.animation_finished.is_connected(switch_state)):
		sprite.animation_finished.connect(switch_state)

func exit() -> void:
	if (sprite.animation_finished.is_connected(switch_state)):
		sprite.animation_finished.disconnect(switch_state)

func physics_update(_delta: float) -> void:
	var bouncy_nodes = get_tree().get_nodes_in_group("Bouncy")
	if player.get_last_slide_collision() != null:
		if bouncy_nodes.has(player.get_last_slide_collision().get_collider()):
			state_machine.transition_to("Bounce")
	
	if player.is_on_floor() and (abs(Input.get_axis("move_left", "move_right")) > 0 or player.get_platform_velocity() != Vector2.ZERO or input_listener.get_buffer("MoveLeftBuffer").is_buffered() or input_listener.get_buffer("MoveRightBuffer").is_buffered()):
		input_listener.get_buffer("MoveLeftBuffer").consume()
		input_listener.get_buffer("MoveRightBuffer").consume()
		state_machine.transition_to("Walk")
	elif (player.is_on_floor() or player.on_coyote) and (Input.is_action_just_pressed("jump") or input_listener.get_buffer("JumpBuffer").is_buffered()):
		input_listener.get_buffer("JumpBuffer").consume()
		state_machine.transition_to("Jump")
	elif player.can_dash and (Input.is_action_just_pressed("dash") or input_listener.get_buffer("DashBuffer").is_buffered()):
		input_listener.get_buffer("DashBuffer").consume()
		state_machine.transition_to("Dash")

func update(_delta: float) -> void:
	sprite.flip_h = player.prev_direction < 0

func switch_state() -> void:
	state_machine.transition_to("Idle")
