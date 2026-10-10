extends State

class_name PlayerStagger

@export var jump_delay: float = 0.1

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()
@onready var input_listener: InputListener = owner.get_node("InputListener")
@onready var sprite : AnimatedSprite2D = player.get_node("AnimatedSprite2D")

@onready var input_frozen: bool = false

func enter() -> void:
	sprite.play("stagger")
	
	if !(sprite.animation_finished.is_connected(switch_state)):
		sprite.animation_finished.connect(switch_state)
		
	player.decel_frame = Time.get_unix_time_from_system()

func exit() -> void:
	if (sprite.animation_finished.is_connected(switch_state)):
		sprite.animation_finished.disconnect(switch_state)

func physics_update(_delta: float) -> void:
	var bouncy_nodes = get_tree().get_nodes_in_group("Bouncy")
	
	if (input_frozen):
		player.velocity.x = 0
		state_machine.transition_to("Idle")
		
	if player.get_last_slide_collision() != null:
		var collision = player.get_last_slide_collision()
		if bouncy_nodes.has(collision.get_collider()):
			if (collision.get_collider().allow_horizontal_bounce and abs(collision.get_normal().x) >= abs(collision.get_normal().y)) or abs(collision.get_normal().y) >= abs(collision.get_normal().x):
				state_machine.transition_to("Bounce")
	
	if not input_frozen and player.can_throw and (Input.is_action_just_pressed("action_throw")):
		state_machine.transition_to("Throw")
			
	if not input_frozen and player.can_throw and (Input.is_action_just_pressed("action_throw")):
		state_machine.transition_to("Throw")
	elif not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif player.is_on_floor() and not input_frozen and (abs(Input.get_axis("move_left", "move_right")) > 0 or input_listener.get_buffer("MoveLeftBuffer").is_buffered() or input_listener.get_buffer("MoveRightBuffer").is_buffered()):
		input_listener.get_buffer("MoveLeftBuffer").consume()
		input_listener.get_buffer("MoveRightBuffer").consume()
		state_machine.transition_to("Walk")
	elif (player.is_on_floor() or player.on_coyote) and not input_frozen and (Input.is_action_just_pressed("jump") or input_listener.get_buffer("JumpBuffer").is_buffered()):
		input_listener.get_buffer("JumpBuffer").consume()
		state_machine.transition_to("Jump")
	elif player.can_dash and not input_frozen and (Input.is_action_just_pressed("dash") or input_listener.get_buffer("DashBuffer").is_buffered()):
		input_listener.get_buffer("JumpBuffer").consume()
		state_machine.transition_to("Dash")

func update(_delta: float) -> void:
	sprite.flip_h = player.mirror_factor[int(player.mirrored)] * player.prev_direction < 0

func switch_state() -> void:
	state_machine.transition_to("Idle")


func _on_player_input_freezed(active: bool) -> void:
	input_frozen = active
