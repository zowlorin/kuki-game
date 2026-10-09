extends State

class_name PlayerThrow

signal projectile_requested

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()
@onready var input_listener: InputListener = owner.get_node("InputListener")

@onready var input_frozen: bool = false

func enter() -> void:
	player.throw_frame = Time.get_unix_time_from_system()
	
	player.get_node("AnimatedSprite2D").play("throw")
	
	projectile_requested.emit()

func exit() -> void:
	pass

func physics_update(_delta: float) -> void:
	var curr_frame = Time.get_unix_time_from_system()
	var bouncy_nodes = get_tree().get_nodes_in_group("Bouncy")
	
	player.get_node("Hurtbox").get_child(0).set_deferred("disabled", true)
	
	player.velocity.y = 0
	
	if (curr_frame - player.throw_frame) >= player.throw_duration:
		state_machine.transition_to("Idle")

func _on_player_input_freezed(active: bool) -> void:
	input_frozen = active
