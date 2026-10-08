extends State

class_name ChudWake

@onready var chud: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()

@onready var sprite : AnimatedSprite2D = chud.get_node("AnimatedSprite2D")

func enter() -> void:
	sprite.play("wake")

func physics_update(_delta: float) -> void:
	var raycast : RayCast2D = chud.get_node("RayCast")
	
	var target = Vector2(chud.target.global_position.x, chud.target.global_position.y - 16)
	raycast.look_at(target)
	
	if !sprite.is_playing():
		state_machine.transition_to("Idle")
