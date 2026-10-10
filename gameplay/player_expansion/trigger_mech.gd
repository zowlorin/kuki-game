extends Area2D

class_name TriggerMech

signal on_triggered(active: bool)
signal hit

@onready var target: Node2D
@onready var player_interacting: bool = false
@onready var active: bool = false

@onready var interacting_list: Array[Node2D] = []

@onready var curr_interacting_size: int = 0
@onready var prev_interacting_size: int = 0

func _on_body_entered(body: Node2D) -> void:
	target = body
	player_interacting=true
	interacting_list.append(body)
	curr_interacting_size = len(interacting_list)
	hit.emit()

func _on_body_exited(body: Node2D) -> void:
	player_interacting=false
	if body in interacting_list:
		interacting_list.erase(body)
	curr_interacting_size = len(interacting_list)

func _process(delta: float) -> void:
	prev_interacting_size = curr_interacting_size
