extends CharacterBody2D

@export_category("Vertical Motion")
@export var jump_curve: Curve
@export var jump_duration: float = 2.0
@export var jump_speed: float = 400.0
@export var fall_curve: Curve
@export var fall_duration: float = 2.0
@export var fall_speed: float = 400.0




@export_category("Horizontal Motion")
@export var accel_curve: Curve
@export var accel_duration: float = 0.5

@export var decel_curve: Curve
@export var decel_duration: float = 0.5

@export var max_speed: float = 300.0
@export var dash_speed: float = 500.0
@export var dash_duration: float = 0.3

@onready var jump_frame = Time.get_unix_time_from_system()
@onready var fall_frame = Time.get_unix_time_from_system()
@onready var accel_frame = Time.get_unix_time_from_system()
@onready var decel_frame = Time.get_unix_time_from_system()
@onready var dash_frame = Time.get_unix_time_from_system()

@onready var was_on_floor: bool = false
@onready var jump_buffered: bool = false
@onready var on_coyote: bool = false
@onready var can_dash: bool = true

@onready var state_manager: StateManager
@onready var curr_states: Array[StateMachine.State] = []
@onready var state_machine : StateMachine = StateMachine.new()

@onready var move_speed: float = 0.0
@onready var move_dash: float = 0.0
@onready var prev_direction: int = 1

func _ready() -> void:
	add_state(StateMachine.State.IDLE)
	add_state(StateMachine.State.FALLING)

func add_state(state: StateMachine.State):
	if curr_states.has(state):
		return
	
	curr_states.append(state)

func fall():
	if (!curr_states.has(StateMachine.State.JUMPING)):
		return
	if (curr_states.has(StateMachine.State.FALLING)):
		return
		
	add_state(StateMachine.State.FALLING)
	curr_states.erase(StateMachine.State.JUMPING)
	
	fall_frame = Time.get_unix_time_from_system()

func jump():
	if (curr_states.has(StateMachine.State.JUMPING)):
		return
	if (!curr_states.has(StateMachine.State.FALLING)):
		return
	
	add_state(StateMachine.State.JUMPING)
	curr_states.erase(StateMachine.State.FALLING)
	get_tree().call_group("JumpTimers", "stop")
	jump_buffered = false
	on_coyote = false
	
	jump_frame = Time.get_unix_time_from_system()
	
func accel():
	if (curr_states.has(StateMachine.State.MOVING)):
		return
	if (!curr_states.has(StateMachine.State.IDLE)):
		return
	add_state(StateMachine.State.MOVING)
	curr_states.erase(StateMachine.State.IDLE)
	accel_frame = Time.get_unix_time_from_system()
	
func decel():
	if (!curr_states.has(StateMachine.State.MOVING)):
		return
	if (curr_states.has(StateMachine.State.IDLE)):
		return
	add_state(StateMachine.State.IDLE)
	curr_states.erase(StateMachine.State.MOVING)
	decel_frame = Time.get_unix_time_from_system()

func dash():
	if (curr_states.has(StateMachine.State.DASHING)):
		return
	
	add_state(StateMachine.State.DASHING)
	dash_frame = Time.get_unix_time_from_system()
	can_dash = false

func _physics_process(delta: float) -> void:
	var curr_frame: float = Time.get_unix_time_from_system()
	
	if is_on_floor():
		velocity.y = 0
		
	if (curr_states.has(StateMachine.State.JUMPING)):
		velocity.y = -(jump_curve.sample((curr_frame - jump_frame) / jump_duration)) * jump_speed;
		
	if (curr_states.has(StateMachine.State.FALLING)):
		velocity.y = (1 - (fall_curve.sample((curr_frame - fall_frame) / fall_duration))) * fall_speed;
		
	if (curr_states.has(StateMachine.State.MOVING)):
		move_speed = accel_curve.sample((curr_frame - accel_frame) / accel_duration) * max_speed
		
	if (curr_states.has(StateMachine.State.IDLE)):
		move_speed = decel_curve.sample((curr_frame - decel_frame) / decel_duration) * max_speed
	
	if (curr_states.has(StateMachine.State.DASHING)):
		$Helpers/DashInvinciblity.start()
		$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
		move_dash = prev_direction * dash_speed
	
	if (curr_frame - dash_frame) >= dash_duration:
		curr_states.erase(StateMachine.State.DASHING)
		move_dash = 0
	
	if (((curr_frame - jump_frame) >= jump_duration or is_on_ceiling() or Input.is_action_just_released("move_jump")) and curr_states.has(StateMachine.State.JUMPING)):
		fall()
	
	if (not is_on_floor() and !curr_states.has(StateMachine.State.JUMPING)):
		fall()

	if (Input.is_action_just_pressed("move_jump") or jump_buffered):
		if $Helpers/JumpBufferer.is_stopped():
			$Helpers/JumpBufferer.start()
			jump_buffered = true
		
		if is_on_floor() or on_coyote:
			jump()
		
	var move_direction: float = Input.get_axis("move_left", "move_right")
	
	if abs(move_direction) > 0:
		prev_direction = move_direction
	
	velocity.x = move_direction * move_speed + move_dash
	
	if abs(move_direction) > 0 and (!curr_states.has(StateMachine.State.MOVING)) and (curr_states.has(StateMachine.State.IDLE)):
		accel()
		
	if move_direction == 0 and (curr_states.has(StateMachine.State.MOVING)) and (!curr_states.has(StateMachine.State.IDLE)):
		decel()
	
	if Input.is_action_just_pressed("dash") and can_dash:
		dash()

	was_on_floor = is_on_floor()
	
	move_and_slide()

	if was_on_floor != is_on_floor() and $Helpers/CoyoteTimer.is_stopped():
		$Helpers/CoyoteTimer.start()
		on_coyote = true
	
	var temp = curr_states.back()
	for state in curr_states:
		if state > temp and is_on_floor():
			temp = state
	change_state(temp)

func change_state(new_state: StateMachine.State):
	if state_manager != null:
		state_manager.queue_free()
	state_manager = state_machine.get_state(new_state).new(self, change_state, $AnimatedSprite2D)
	add_child(state_manager)

func _on_jump_bufferer_timeout() -> void:
	jump_buffered = false

func _on_coyote_timer_timeout() -> void:
	on_coyote = false

func _on_dash_invinciblity_timeout() -> void:
	$Hurtbox/CollisionShape2D.set_deferred("disabled", false)
	$Helpers/DashCooldown.start()

func _on_dash_cooldown_timeout() -> void:
	can_dash = true

func _on_hurtbox_area_entered(area: Area2D) -> void:
	print(area)
