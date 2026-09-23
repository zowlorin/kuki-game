extends State

class_name PlayerStagger

@export var jump_delay: float = 0.2

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()
@onready var sprite : AnimatedSprite2D = player.get_node("AnimatedSprite2D")

@onready var is_jump : bool = false

func enter() -> void:
	sprite.play("stagger")
	if Input.is_action_just_pressed("move_jump"):
		sprite.play("stagger", -(1/jump_delay), true)
		is_jump = true
	
	if !(sprite.animation_finished.is_connected(switch_state)):
		print("connected")
		sprite.animation_finished.connect(switch_state)

func exit() -> void:
	if (sprite.animation_finished.is_connected(switch_state)):
		sprite.animation_finished.disconnect(switch_state)

func physics_update(_delta: float) -> void:
	pass

func update(_delta: float) -> void:
	sprite.flip_h = player.prev_direction < 0

func switch_state() -> void:
	print(is_jump)
	if is_jump:
		state_machine.transition_to("Jump")
	else:
		state_machine.transition_to("Idle")
