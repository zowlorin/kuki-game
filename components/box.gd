extends RigidBody2D

func _physics_process(delta: float) -> void:
	if $AnimatedSprite2D.animation != "moving" and abs(linear_velocity.x) > 0:
		$AnimatedSprite2D.play("moving")
	elif abs(linear_velocity.x) == 0:
		$AnimatedSprite2D.play("stationary")
