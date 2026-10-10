extends Node2D

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
	
	door_entered.emit(body, rel, target_door)

func _on_body_entered(body: Node2D) -> void:
	if (body is Player and !automatic):
		player = body
		player_interacting = true
		return
	
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
	
func receive_body_teleport_request(body: Node2D, relative: Vector2, target: Node2D) -> void:
	target.ignore_list.append(body)
	target.teleport(body, relative)
	
func on_interact():
	if (automatic):
		return
	if (!player):
		return
	if (!player_interacting):
		return
	on_enter(player)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_interacting:
		on_interact()
