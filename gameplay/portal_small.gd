extends Area2D

class_name SmallPortal

signal portal_entered(body: Node2D, relative: Vector2, target: Node2D)

@export var target_portal: SmallPortal

@onready var ignore_list: Array[Node2D] = []

func _on_body_entered(body: Node2D) -> void:
	if body in ignore_list:
		return
	var rel: Vector2 = body.global_position - global_position
	print("gugu" + name)
	portal_entered.emit(body, rel, target_portal)

func _on_body_exited(body: Node2D) -> void:
	if not body in ignore_list:
		return
	ignore_list.erase(body)
	
func teleport(body: Node2D, relative: Vector2) -> void:
	body.global_position = global_position + relative
	
func receive_body_teleport_request(body: Node2D, relative: Vector2) -> void:
	ignore_list.append(body)
	
	teleport(body, relative)
