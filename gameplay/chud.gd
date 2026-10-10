extends CharacterBody2D

@export var buffer_frames = 3

@onready var target: CharacterBody2D = get_tree().current_scene.get_node("World/Player")
@onready var state_machine: StateMachine = $StateMachine

@onready var cookie_handler = get_tree().current_scene.get_node("Handlers/CookieCollectHandler")

@onready var player_interacting: bool = false

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


func _on_interact_area_body_entered(body: Node2D) -> void:
	player_interacting = true


func _on_interact_area_body_exited(body: Node2D) -> void:
	player_interacting = false
	
func on_interact():
	if (not cookie_handler.can_feed_cookies()):
		return
	cookie_handler.on_cookie_fed()
	state_machine.transition_to("Eating")
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		on_interact()
