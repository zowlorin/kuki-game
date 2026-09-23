extends Node

class_name State

# Called once when this state becomes active
func enter() -> void:
	pass
 
# Called once when this state is replaced by another
func exit() -> void:
	pass
 
# Called every physics frame while this state is active
func physics_update(_delta: float) -> void:
	pass
 
# Called every frame while this state is active
func update(_delta: float) -> void:
	pass
