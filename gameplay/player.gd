extends CharacterBody2D

class_name Player

signal freezed(active: bool)
signal input_freezed(active: bool)
signal request_projectile(name: String, position: Vector2, extra: Dictionary)

signal respawned
signal died

signal safe_zone_requested

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
@export var max_dash_cooldown : float = 0.4

@export_category("Miscellanous")
@export var mirrored: bool = false
@export var push_force: float = 10
@export var bounce_curve: Curve
@export var bounce_speed: float = 300.0
@export var bounce_duration: float = 0.4
@export var throw_duration: float = 0.2


@onready var jump_frame = Time.get_unix_time_from_system()
@onready var fall_frame = Time.get_unix_time_from_system()
@onready var accel_frame = Time.get_unix_time_from_system()
@onready var decel_frame = Time.get_unix_time_from_system()
@onready var dash_frame = Time.get_unix_time_from_system()
@onready var throw_frame = Time.get_unix_time_from_system()

@onready var was_on_floor: bool = false
@onready var jumped_last_frame: bool = false
@onready var jump_buffered: bool = false
@onready var on_coyote: bool = false
@onready var can_dash: bool = true
@onready var can_throw: bool = true:
	set(x):
		can_throw = x
		if (!can_throw):
			$Helpers/ThrowCooldown.start()

@onready var mirror_factor: Array[int] = [1, -1]
@onready var prev_direction: float = 1.0

@onready var helpers: Node = $Helpers
@onready var state_machine: StateMachine = $StateMachine

@onready var velocity_snapshot: Vector2 = Vector2.ZERO

var frozen: bool = false:
	set(x):
		if (frozen == x):
			return
		frozen = x
		if (frozen):
			velocity_snapshot = velocity
			velocity = Vector2.ZERO
		else:
			velocity = velocity_snapshot
		freezed.emit(frozen)
		
var input_frozen: bool = false:
	set(x):
		if (input_frozen == x):
			return
		input_frozen = x
		input_freezed.emit(x)
		
@onready var respawn_target: SafeZone

func _ready() -> void:
	frozen = true
	input_frozen = true

func _physics_process(_delta: float) -> void:
	var move_direction: float = Input.get_axis("move_left", "move_right")
	
	if (input_frozen):
		move_direction = 0
	
	if abs(move_direction) > 0:
		prev_direction = move_direction
	
	was_on_floor = is_on_floor()
	move_and_slide()
	
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

func on_respawn():
	input_frozen = false
	
	velocity = Vector2.ZERO

func on_death():
	input_frozen = true
	
	frozen = true
	
	velocity = Vector2.ZERO
	
	died.emit()
	
	$Helpers/DeathTimer.start()
	
	state_machine.transition_to("Idle")
	
func _on_hurtbox_hurt() -> void:
	on_death()

func _on_respawn_timer_timeout() -> void:
	on_respawn()

func _on_respawn_handler_safe_zone_granted(target: SafeZone) -> void:
	respawn_target = target
	
	if respawn_target:
		global_position = respawn_target.global_position
	
	velocity = Vector2.ZERO
	frozen = false

func _on_death_timer_timeout() -> void:
	$Helpers/RespawnTimer.start()
	
	safe_zone_requested.emit()


func _on_throw_projectile_requested() -> void:
	request_projectile.emit("player_cap", global_position, {})


func _on_throw_cooldown_timeout() -> void:
	can_throw = true


func _on_level_handler_level_okay() -> void:
	frozen = false
	input_frozen = false
func _on_level_handler_on_level_setup_done():
	pass
