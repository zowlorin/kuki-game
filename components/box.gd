extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if $AnimatedSprite2D.animation != "moving" and abs(linear_velocity.x) > 0:
		$AnimatedSprite2D.play("moving")
	elif abs(linear_velocity.x) == 0:
		$AnimatedSprite2D.play("stationary")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
