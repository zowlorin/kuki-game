extends Node

class_name StateManager

var change_state: Callable
var sprite: AnimatedSprite2D
var state: Node2D

func _ready() -> void:
	self.name = "current_state"

func _init(state: Node2D, state_changer: Callable, sprite: AnimatedSprite2D) -> void:
	self.change_state = state_changer
	self.sprite = sprite
	self.state = state
