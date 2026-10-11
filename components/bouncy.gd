extends StaticBody2D

@export var allow_horizontal_bounce: bool = false

func _ready() -> void:
	self.add_to_group("Bouncy")
