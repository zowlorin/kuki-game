extends CharacterBody2D

@export var target: CharacterBody2D
@export var buffer_frames = 3

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func play_animation(animation: String) -> void:
	$AnimationPlayer.play(animation)

func stop_animation() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("RESET")
