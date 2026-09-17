extends CharacterBody2D

@export var jump_curve: Curve
@export var fall_curve: Curve
@export var jump_duration: float = 2.0
@export var fall_duration: float = 2.0

@export var jump_speed = 400.0
@export var fall_speed = 400.0
@export var move_speed = 400.0

@onready var jump_frame = Time.get_unix_time_from_system()
@onready var fall_frame = Time.get_unix_time_from_system()

enum State {
	IDLE, MOVING, JUMPING, FALLING
}

@onready var was_on_floor: bool = false

@onready var curr_state: State = State.IDLE

func jump():
	curr_state = State.JUMPING
	jump_frame = Time.get_unix_time_from_system()
	
	velocity.y = -jump_speed
	
func fall():
	curr_state = State.FALLING
	fall_frame = Time.get_unix_time_from_system()
	
func _physics_process(delta: float) -> void:
	var curr_frame: float = Time.get_unix_time_from_system()
	
	if not is_on_floor() and (curr_state != State.FALLING and curr_state != State.JUMPING):
		fall()
	
	if is_on_floor():
		curr_state = State.IDLE
		velocity.y = 0
		
	if (curr_state == State.JUMPING):
		velocity.y = -(jump_curve.sample((curr_frame - jump_frame) / jump_duration)) * jump_speed;
		
	if (curr_state == State.FALLING):
		velocity.y = (1 - fall_curve.sample((curr_frame - fall_frame) / fall_duration)) * fall_speed;
		
	if ((curr_frame - jump_frame) >= jump_duration and curr_state == State.JUMPING or is_on_ceiling()):
		fall()

	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		jump()
		
	var move_direction: float = Input.get_axis("move_left", "move_right")
	
	velocity.x = move_direction * move_speed

	was_on_floor = is_on_floor()
	
	move_and_slide()
