extends TriggerMech

@export var hold_duration: float = 1.0

@onready var prev_interacting: bool = false

func _ready():
	$Timer.wait_time = hold_duration

func trigger():
	active = player_interacting
	
	$Sprite2D.frame = 1 if active else 0
	
	on_triggered.emit(active)

func _process(delta: float) -> void:
	if (prev_interacting_size != curr_interacting_size):
		if (curr_interacting_size == 0):
			$Timer.start()
		else:
			trigger()
		
	prev_interacting = player_interacting


func _on_timer_timeout() -> void:
	trigger()
