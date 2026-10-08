extends Area2D

class_name TriggerMech

signal on_triggered(active: bool)

@onready var player_interacting: bool = false
@onready var active: bool = false

func _on_body_entered(body: Node2D) -> void:
	player_interacting=true

func _on_body_exited(body: Node2D) -> void:
	player_interacting=false
	
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
