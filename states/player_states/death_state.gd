extends State

class_name PlayerDeath

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()

func enter() -> void:
	player.died.emit()
	AudioManager.play("DeathSFX")
	player.get_node("AnimatedSprite2D").play("death")
	player.helpers.get_node("DeathTimer").start()
	
