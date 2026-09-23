extends State

class_name PlayerFall

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()
@onready var sprite: AnimatedSprite2D = player.get_node("AnimatedSprite2D")

@onready var stagger: bool = false

func enter() -> void:
	sprite.play("fall")
	player.fall_frame = Time.get_unix_time_from_system()

func exit() -> void:
	self.name = "Fall"
	if (sprite.animation_finished.is_connected(_on_animation_finish)):
		sprite.animation_finished.disconnect(_on_animation_finish)

func physics_update(_delta: float) -> void:
	if player.is_on_floor():
		if !(sprite.animation_finished.is_connected(_on_animation_finish)):
			sprite.animation_finished.connect(_on_animation_finish)
		
		if sprite.animation != "stagger":
			sprite.stop()
			sprite.play("stagger")
			self.name = "Stagger"
			stagger = true
	
	# idk abt this; required to show land anim but breaks p6
	#if stagger:
		#player.move_speed = 0
		#return
	
	if player.is_on_floor() and (player.move_speed > 0):
		state_machine.transition_to("Walk")
	elif (player.is_on_floor() or player.on_coyote) and Input.is_action_just_pressed("move_jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
	elif player.is_on_floor():
		state_machine.transition_to("Idle")
	
	var curr_frame = Time.get_unix_time_from_system()
	
	player.velocity.y = (1 - (player.fall_curve.sample((curr_frame - player.fall_frame) / player.fall_duration))) * player.fall_speed

func update(_delta: float) -> void:
	sprite.flip_h = player.prev_direction < 0

func _on_animation_finish() -> void:
	self.name = "Fall"
	stagger = false
