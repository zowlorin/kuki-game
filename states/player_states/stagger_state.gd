extends State

class_name PlayerStagger

@export var jump_delay: float = 0.1

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()
@onready var sprite : AnimatedSprite2D = player.get_node("AnimatedSprite2D")


func enter() -> void:
	sprite.play("stagger")
	
	if !(sprite.animation_finished.is_connected(switch_state)):
		sprite.animation_finished.connect(switch_state)

func exit() -> void:
	if (sprite.animation_finished.is_connected(switch_state)):
		sprite.animation_finished.disconnect(switch_state)

func physics_update(_delta: float) -> void:
	if abs(Input.get_axis("move_left", "move_right")) > 0:
		state_machine.transition_to("Walk")
	elif Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")

func update(_delta: float) -> void:
	sprite.flip_h = player.prev_direction < 0

func switch_state() -> void:
	state_machine.transition_to("Idle")
