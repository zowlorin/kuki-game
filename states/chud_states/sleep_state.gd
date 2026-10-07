extends State

class_name ChudSleep

@onready var chud: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()

@onready var idle_frame = Time.get_unix_time_from_system()

func enter() -> void:
	chud.get_node("AnimatedSprite2D").play("sleep")

func physics_update(_delta: float) -> void:
	var raycast : RayCast2D = chud.get_node("RayCast")
	
	var target = Vector2(chud.target.global_position.x, chud.target.global_position.y - 16)
	raycast.look_at(target)
	
	if raycast.is_colliding():
		state_machine.transition_to("Idle")
