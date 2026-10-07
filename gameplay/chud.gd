extends CharacterBody2D

@export var target: CharacterBody2D
@export var frames_before_sleep = 3

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
