extends Area2D
class_name Portal

@export var enabled: bool = true
@export var id: String
@export var target_id: String

signal level_change_requested(target_level: String, target_id: String)

@onready var player_interacting: bool = false

@export_file("*.tscn") var target_level: String

func _ready() -> void:
	if ((!target_id|| !id || !target_level) && enabled):
		enabled = false
		visible = false
		print("portal kinda cooked, disabling it")

func _on_body_entered(body: Node2D) -> void:
	player_interacting=true

func _on_body_exited(body: Node2D) -> void:
	player_interacting=false
	
func load_target_level():
	if (!target_level):
		return
	level_change_requested.emit(target_level, target_id)
	
func on_interact():
	if (!enabled):
		return
		
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
