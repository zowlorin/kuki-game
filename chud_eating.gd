extends State
class_name ChudEating

@onready var chud: CharacterBody2D = owner
@onready var state_machine: StateMachine = get_parent()

@onready var idle_frame = Time.get_unix_time_from_system()

func enter() -> void:
	chud.get_node("AnimatedSprite2D").play("eating")
	$Timer.start()
	
func exit() -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	state_machine.transition_to("Dancing")
