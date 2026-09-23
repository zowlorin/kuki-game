extends Node

@export var pixel_shift: float = 25
@export var shift_curve: Curve

@onready var shift_direction: float
@onready var curr_shift: float

@onready var return_frame: float
@onready var shift_frame: float

@onready var shift_buffered: bool

func _process(_delta: float) -> void:
	var curr_frame: float = Time.get_unix_time_from_system()
	
	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down") or shift_buffered:
		curr_shift = $"../../World/Camera2D".offset.y
		shift_buffered = true
		shift_frame = 0
		
		if curr_shift == 0:
			shift_frame = Time.get_unix_time_from_system()
			shift_buffered = false
			
	elif Input.is_action_just_released("up") or Input.is_action_just_released("down"):
		return_frame = Time.get_unix_time_from_system()
		curr_shift = $"../../World/Camera2D".offset.y
	
	shift_direction = Input.get_axis("up", "down")
	
	if abs(shift_direction) > 0 and not shift_buffered:
		$"../../World/Camera2D".offset.y = shift_direction * shift_curve.sample((curr_frame - shift_frame)) * pixel_shift
	else:
		$"../../World/Camera2D".offset.y = (1 - shift_curve.sample((curr_frame - return_frame))) * curr_shift
