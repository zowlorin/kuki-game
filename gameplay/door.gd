extends Area2D

class_name Door

signal door_entered(body: Node2D, relative: Vector2, target: Node2D)

@export var target_door: Door

@onready var ignore_list: Array[Node2D] = []

func on_enter(body: Node2D):
	if (!target_door):
		return
		
	var rel: Vector2 = body.global_position - global_position
	
	door_entered.emit(body, rel, target_door)

func _on_body_entered(body: Node2D) -> void:
	if body in ignore_list:
		return
	
	on_enter(body)
	

func _on_body_exited(body: Node2D) -> void:
	if not body in ignore_list:
		return
	ignore_list.erase(body)
	
func teleport(body: Node2D, relative: Vector2) -> void:
	body.global_position = global_position + relative
	
func receive_body_teleport_request(body: Node2D, relative: Vector2) -> void:
	ignore_list.append(body)
	
	teleport(body, relative)
