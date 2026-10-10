extends Area2D

class_name CameraArea

signal entered(focus: Node2D)
signal exited(focus: Node2D)

@onready var relevant: Array[Node2D] = []

func _on_body_entered(body: Node2D) -> void:
	entered.emit($Focus)
	relevant.append(body)

func _on_body_exited(body: Node2D) -> void:
	exited.emit($Focus)
	relevant.erase(body)
