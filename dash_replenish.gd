extends Area2D

class_name DashReplenish

func deactivate():
	await get_tree().process_frame
	visible = false
	$CollisionShape2D.set_deferred("disabled",true)
	$Timer.start()

func _on_body_entered(body: Node2D) -> void:
	deactivate()

func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.

func _on_timer_timeout() -> void:
	visible = true
	$CollisionShape2D.set_deferred("disabled",false)
