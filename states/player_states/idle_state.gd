extends State

class_name PlayerIdle

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()
@onready var input_listener: InputListener = owner.get_node("InputListener")

@onready var input_frozen: bool = false

func enter() -> void:
	player.get_node("AnimatedSprite2D").play("idle")
	player.decel_frame = Time.get_unix_time_from_system()

func physics_update(_delta: float) -> void:
	var bouncy_nodes = get_tree().get_nodes_in_group("Bouncy")
	
	if player.get_last_slide_collision() != null:
		if bouncy_nodes.has(player.get_last_slide_collision().get_collider()):
			state_machine.transition_to("Bounce")

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
	player.get_node("AnimatedSprite2D").flip_h = (player.mirror_factor[int(player.mirrored)] * player.prev_direction) < 0


func _on_player_input_freezed(active: bool) -> void:
	input_frozen = active
