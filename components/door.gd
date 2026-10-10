extends Area2D

class_name Door

@export var automatic: bool = false

signal door_entered(body: Node2D, relative: Vector2, target: Node2D)

@export var target_door: Door

@onready var ignore_list: Array[Node2D] = []
@onready var player_interacting: bool = false

@onready var player: Player

func on_enter(body: Node2D):
	if (!target_door):
		return
		
	var rel: Vector2 = body.global_position - global_position
	
	print('ogeiiii')
	
	door_entered.emit(body, rel, target_door)

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		player = body
		player_interacting = true
	
	if (!automatic):
		return
		
	if body in ignore_list:
		return
	
	on_enter(body)
	

func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		player_interacting = false
		
	if (!automatic):
		return
	
	if not body in ignore_list:
		return
	ignore_list.erase(body)
	
func teleport(body: Node2D, relative: Vector2) -> void:
	body.global_position = global_position + relative
	
func receive_body_teleport_request(body: Node2D, relative: Vector2) -> void:
	if (automatic):
		ignore_list.append(body)
	
	teleport(body, relative)
	
func on_interact():
	if (automatic):
		return
	if (!player):
		return
	if (!player_interacting):
		return
	on_enter(player)
	
func _input(event: InputEvent) -> void:
	
	if not event is InputEventKey:
		return
		
	var ev: InputEventKey = event

	if (!ev.pressed):
		return
	
	if (!ev.keycode == Key.KEY_E):
		return
		
	on_interact()
