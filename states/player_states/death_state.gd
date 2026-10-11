extends State

class_name PlayerDeath

@onready var player: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()
@export var death_particles: CPUParticles2D

func enter() -> void:
	player.died.emit()
	death_particles.global_position = owner.global_position
	death_particles.restart()
	death_particles.emitting = true
	AudioManager.play("DeathSFX")
	player.get_node("AnimatedSprite2D").play("death")
	player.helpers.get_node("DeathTimer").start()
	
