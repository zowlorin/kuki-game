extends State

class_name PlayerBounce

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()

@onready var bounce_frame = Time.get_unix_time_from_system()
@onready var collision = player.get_last_slide_collision()

@onready var input_frozen: bool = false

func enter() -> void:
	player.get_node("AnimatedSprite2D").play("jump")
	
	AudioManager.play("BounceSFX")
	
	collision = player.get_last_slide_collision()
	bounce_frame = Time.get_unix_time_from_system()

func exit() -> void:
	if collision.get_collider().name == "ChudBody":
		var body = collision.get_collider()
		body.owner.get_node("AnimatedSprite2D").play("idle")

func physics_update(_delta: float) -> void:
	var move_direction = Input.get_axis("move_left", "move_right")
	var curr_frame = Time.get_unix_time_from_system()
	
	if input_frozen:
		move_direction = 0
		
	if not input_frozen  and player.can_throw and (Input.is_action_just_pressed("action_throw")):
		state_machine.transition_to("Throw")
	
	if ((curr_frame - bounce_frame) >= player.bounce_duration or collision == null) and player.is_on_floor():
		state_machine.transition_to("Idle")
	
	var bounce_vel = collision.get_normal() * (player.bounce_curve.sample((curr_frame - bounce_frame) / player.bounce_duration)) * player.bounce_speed
	var bounciness = lerp(collision.get_collider().physics_material_override.bounce, 0.8, (curr_frame - bounce_frame)/player.bounce_duration)
	
	if collision.get_collider().allow_horizontal_bounce:
		var body = collision.get_collider()
		if abs(collision.get_normal().x) >= abs(collision.get_normal().y):
			body.owner.play_animation("h_bounce")
		else:
			body.owner.play_animation("v_bounce")
	
	if collision.get_collider().allow_horizontal_bounce:
		player.velocity.x = bounce_vel.x + player.mirror_factor[int(player.mirrored)] * move_direction * player.accel_curve.sample((curr_frame - player.accel_frame) / player.accel_duration) * player.max_speed
	else:
		player.velocity.x = player.mirror_factor[int(player.mirrored)] * move_direction * player.accel_curve.sample((curr_frame - player.accel_frame) / player.accel_duration) * player.max_speed
	player.velocity.y = bounce_vel.y + bounciness * (1 - (player.fall_curve.sample((curr_frame - player.fall_frame) / player.fall_duration))) * player.fall_speed

func _on_player_input_freezed(active: bool) -> void:
	input_frozen = active
