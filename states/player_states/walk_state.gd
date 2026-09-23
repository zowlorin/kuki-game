extends State

class_name PlayerWalk

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()

@onready var move_direction: float = 0

func enter() -> void:
	player.get_node("AnimatedSprite2D").play("walk")
	
	move_direction = Input.get_axis("move_left", "move_right")
	if abs(move_direction) <= 0:
		player.accel_frame = Time.get_unix_time_from_system()

func physics_update(delta: float) -> void:
	move_direction = Input.get_axis("move_left", "move_right")
	
	if not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("move_jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	elif abs(move_direction) == 0:
		state_machine.transition_to("Idle")
	
	var curr_frame = Time.get_unix_time_from_system()
	
	player.move_speed = player.accel_curve.sample((curr_frame - player.accel_frame) / player.accel_duration) * player.max_speed

func update(_delta: float) -> void:
	player.get_node("AnimatedSprite2D").flip_h = player.velocity.x < 0
