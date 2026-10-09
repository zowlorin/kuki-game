extends Node2D

@export var offset: Vector2 = Vector2.ZERO

@onready var player: Player = get_parent().get_parent()

func _physics_process(delta: float) -> void:
	global_position = player.global_position + Vector2(offset.x*player.prev_direction,offset.y)
