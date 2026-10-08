extends Node2D


func _on_small_portal_portal_entered(body: Node2D, relative: Vector2, target: Node2D) -> void:
	target.receive_body_teleport_request(body, relative)
