extends TriggerMech

@onready var prev_interacting: bool = false

func trigger():
	active = player_interacting
	
	$Sprite2D.frame = 1 if active else 0
	
	on_triggered.emit(active)

func _process(delta: float) -> void:
	if (prev_interacting != player_interacting):
		if (!player_interacting):
			$Timer.start()
		else:
			trigger()
		
	prev_interacting = player_interacting


func _on_timer_timeout() -> void:
	trigger()
