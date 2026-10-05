extends Area2D

signal level_change_requested

@onready var player_interacting: bool = false

@export_file("*.tscn") var target_level: String
func _on_body_entered(body: Node2D) -> void:
	player_interacting=true

func _on_body_exited(body: Node2D) -> void:
	player_interacting=false
	
func load_target_level():
	if (!target_level):
		return
	level_change_requested.emit(target_level)
	
func on_interact():
	if (!player_interacting):
		return
	
	load_target_level()
	
func _input(event: InputEvent) -> void:
	
	if not event is InputEventKey:
		return
		
	var ev: InputEventKey = event

	if (!ev.pressed):
		return
	
	if (!ev.keycode == Key.KEY_E):
		return
		

		
	on_interact()
