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

@export var max_speed: float = 200.0
@export var dash_speed: float = 500.0
@export var dash_duration: float = 0.3

@onready var jump_frame = Time.get_unix_time_from_system()
@onready var fall_frame = Time.get_unix_time_from_system()
@onready var accel_frame = Time.get_unix_time_from_system()
@onready var decel_frame = Time.get_unix_time_from_system()
@onready var dash_frame = Time.get_unix_time_from_system()

@onready var was_on_floor: bool = false
@onready var jumped_last_frame: bool = false
@onready var jump_buffered: bool = false
@onready var on_coyote: bool = false
@onready var can_dash: bool = true

@onready var move_speed: float = 0.0
@onready var move_dash: float = 0.0
@onready var prev_direction: float = 1.0

@onready var helpers: Node = $Helpers
@onready var state_machine: StateMachine = $StateMachine

func _physics_process(_delta: float) -> void:
	var move_direction: float = Input.get_axis("move_left", "move_right")

	if abs(move_direction) > 0:
		prev_direction = move_direction

	velocity.x = move_direction * move_speed + move_dash
	
	was_on_floor = is_on_floor()
	move_and_slide()
#
	if was_on_floor != is_on_floor() and $Helpers/CoyoteTimer.is_stopped():
		$Helpers/CoyoteTimer.start()
		on_coyote = true

func _on_coyote_timer_timeout() -> void:
	on_coyote = false

func _on_dash_invinciblity_timeout() -> void:
	$Hurtbox/CollisionShape2D.set_deferred("disabled", false)
	$Helpers/DashCooldown.start()

func _on_dash_cooldown_timeout() -> void:
	can_dash = true

func _on_hurtbox_area_entered(area: Area2D) -> void:
	print(area)
