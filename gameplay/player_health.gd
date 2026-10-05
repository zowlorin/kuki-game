extends Node2D

@export var max_health: float = 10

signal health_changed
signal health_emptied
signal health_filled

@onready var health: float = 0:
	set(x):
		x = min(max_health,x)
		if (max_health == x and health < max_health):
			health_filled.emit()
		if (x == 0 and health > 0):
			health_emptied.emit()
		health = x
		health_changed.emit(health)
