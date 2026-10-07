extends State

class_name PlayerBounce

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()

@onready var bounce_frame = Time.get_unix_time_from_system()
@onready var collision = player.get_last_slide_collision()

func enter() -> void:
	player.get_node("AnimatedSprite2D").play("jump")
	
	collision = player.get_last_slide_collision()
	bounce_frame = Time.get_unix_time_from_system()

func physics_update(_delta: float) -> void:
	var move_direction = Input.get_axis("move_left", "move_right")
	var curr_frame = Time.get_unix_time_from_system()
	
	if (curr_frame - bounce_frame) >= player.bounce_duration or collision == null:
		state_machine.transition_to("Fall")
	
	var bounce_vel = collision.get_normal() * (player.bounce_curve.sample((curr_frame - bounce_frame) / player.bounce_duration)) * player.bounce_speed
	
	player.velocity.x = bounce_vel.x + move_direction * player.accel_curve.sample((curr_frame - player.accel_frame) / player.accel_duration) * player.max_speed
	player.velocity.y = bounce_vel.y
