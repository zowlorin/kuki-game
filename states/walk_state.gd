extends StateManager

class_name WalkState

func _ready() -> void:
	sprite.play("walk")

func _process(_delta: float) -> void:
	sprite.flip_h = state.velocity.x < 0
