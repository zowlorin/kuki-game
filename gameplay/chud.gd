extends CharacterBody2D

@export var buffer_frames = 3

@onready var target: CharacterBody2D = get_tree().current_scene.get_node("World/Player")
@onready var state_machine: StateMachine = $StateMachine

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func play_animation(animation: String) -> void:
	$AnimationPlayer.play(animation)

func stop_animation() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("RESET")

func _on_sleep_sfx_finished() -> void:
	await get_tree().create_timer(0.5).timeout
	
	if not $SleepSFX.is_playing() and state_machine.current_state.name == "Sleep":
		$SleepSFX.play()

func _on_idle_sfx_finished() -> void:
	await get_tree().create_timer(randi_range(5.0, 10.0)).timeout
	
	if not $IdleSFX.is_playing() and state_machine.current_state.name == "Idle":
		$IdleSFX.play()
