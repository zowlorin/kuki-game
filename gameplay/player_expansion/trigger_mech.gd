extends Area2D

class_name TriggerMech

signal on_triggered(active: bool)

@onready var target: Node2D
@onready var player_interacting: bool = false
@onready var active: bool = false

func _on_body_entered(body: Node2D) -> void:
	target = body
	player_interacting=true
	print(body)

func _on_body_exited(body: Node2D) -> void:
	player_interacting=false
	
