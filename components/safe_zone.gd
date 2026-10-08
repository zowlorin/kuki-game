extends Area2D

class_name SafeZone

signal player_entered(zone: SafeZone)

func _on_body_entered(body: Node2D) -> void:
	player_entered.emit(self)
