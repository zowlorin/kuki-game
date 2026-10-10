extends TriggerMech

@onready var cooling: bool = false

func trigger():
	active = !active
	
	$Sprite2D.frame = 1 if active else 0
	
	on_triggered.emit(active)

func on_interact():
	if (cooling):
		return
	
	trigger()
	
	cooling = true
	$Timer.start()
	
func _input(event: InputEvent) -> void:
	
	if not event is InputEventKey:
		return
		
	var ev: InputEventKey = event

	if (!ev.pressed):
		return
	
	if (!ev.keycode == Key.KEY_E):
		return
		
	if (!player_interacting):
		return
		
	on_interact()


func _on_timer_timeout() -> void:
	cooling = false

func _on_hit() -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if (area is CapMarker):
		on_interact()
