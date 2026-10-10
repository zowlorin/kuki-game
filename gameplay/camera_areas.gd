extends Node2D

signal player_entered(focus: Node2D)
signal player_exited(focus: Node2D)

func on_entered(focus: Node2D):
	player_entered.emit(focus)
	
func on_exited(focus: Node2D):
	player_exited.emit(focus)

func _ready() -> void:
	for child in get_children():
		if child is CameraArea:
			child.connect("entered",on_entered)
			child.connect("exited",on_exited)
