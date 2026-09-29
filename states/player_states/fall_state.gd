extends State

class_name PlayerFall

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()
@onready var sprite: AnimatedSprite2D = player.get_node("AnimatedSprite2D")

@onready var stagger: bool = false

func enter() -> void:
	sprite.play("fall")
	player.fall_frame = Time.get_unix_time_from_system()

func physics_update(_delta: float) -> void:
	if player.is_on_floor():
		emit_land_particles()
		state_machine.transition_to("Stagger")
	if player.is_on_floor() and (abs(Input.get_axis("move_left", "move_right")) > 0):
		state_machine.transition_to("Walk")
	elif (player.is_on_floor() or player.on_coyote) and Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")
	
	var curr_frame = Time.get_unix_time_from_system()
	
	player.velocity.y = (1 - (player.fall_curve.sample((curr_frame - player.fall_frame) / player.fall_duration))) * player.fall_speed

func emit_land_particles() -> void:
	player.helpers.get_node('LLandParticles').global_position = player.global_position + Vector2(-10, 0)
	player.helpers.get_node('RLandParticles').global_position = player.global_position + Vector2(10, 0)
	player.helpers.get_node('LLandParticles').emitting = true
	player.helpers.get_node('RLandParticles').emitting = true



func update(_delta: float) -> void:
	sprite.flip_h = player.prev_direction < 0
