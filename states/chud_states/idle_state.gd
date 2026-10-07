extends State

class_name ChudIdle

@onready var chud: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()

@onready var idle_frame = Time.get_unix_time_from_system()

func enter() -> void:
	chud.get_node("AnimatedSprite2D").play("idle")
	idle_frame = Time.get_unix_time_from_system()
 
func physics_update(_delta: float) -> void:
	var curr_frame = Time.get_unix_time_from_system()
	var raycast : RayCast2D = chud.get_node("RayCast")
	
	var target = Vector2(chud.target.global_position.x, chud.target.global_position.y - 16)
	raycast.look_at(target)
	
	if (curr_frame - idle_frame) > chud.frames_before_sleep and !raycast.is_colliding():
		state_machine.transition_to("Sleep")
