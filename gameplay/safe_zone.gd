extends Area2D

class_name SafeZone

signal player_entered(recall_position: Vector2)

func _on_body_entered(body: Node2D) -> void:
	player_entered.emit(global_position)
