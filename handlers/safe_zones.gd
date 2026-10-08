extends Node2D

@onready var stored_recall_position: Vector2 = Vector2.ZERO

func on_zone_enter(recall_position: Vector2):
	stored_recall_position = recall_position

func _ready():
	for child in get_children():
		if (child is not SafeZone):
			continue
		child.connect("player_entered", on_zone_enter)
