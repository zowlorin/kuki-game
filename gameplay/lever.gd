extends TriggerMech

func trigger():
	active = !active
	
	$Sprite2D.frame = 1 if active else 0
	
	on_triggered.emit(active)

func on_interact():
	if (!player_interacting):
		return
	
	trigger()
	
func _input(event: InputEvent) -> void:
	
	if not event is InputEventKey:
		return
		
	var ev: InputEventKey = event

	if (!ev.pressed):
		return
	
	if (!ev.keycode == Key.KEY_E):
		return
		
	on_interact()
