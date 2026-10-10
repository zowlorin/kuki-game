extends State

class_name PlayerDeath

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()

func enter() -> void:
	AudioManager.play("DeathSFX")
	player.get_node("AnimatedSprite2D").play("stagger")
	player.died.emit()
	player.helpers.get_node("DeathTimer").start()
 
# Called once when this state is replaced by another
func exit() -> void:
	player.get_node("AnimatedSprite2D").play("idle")
