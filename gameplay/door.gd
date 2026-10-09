extends Node2D


func on_door_enter(body: Node2D, relative: Vector2, target: Node2D) -> void:
	target.receive_body_teleport_request(body, relative)

func _ready() -> void:
	for child in get_children():
		if not child is Door: continue
		child.connect("door_entered", on_door_enter)
