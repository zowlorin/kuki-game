extends Area2D

signal hurt()


func on_hurt():
	hurt.emit()

func _on_body_entered(body: Node2D) -> void:
	on_hurt()
