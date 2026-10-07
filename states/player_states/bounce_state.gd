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
	var curr_frame = Time.get_unix_time_from_system()
	
	if (curr_frame - bounce_frame) >= player.bounce_duration or collision == null:
		state_machine.transition_to("Fall")
	
	var bounce_speed = collision.get_normal() * (player.bounce_curve.sample((curr_frame - bounce_frame) / player.bounce_duration)) * player.bounce_speed
	var fall_speed = (1 - (player.fall_curve.sample((curr_frame - bounce_frame) / player.fall_duration))) * player.fall_speed
	
	player.horizontal_bounce = bounce_speed.x
	player.velocity.y = bounce_speed.y
