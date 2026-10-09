extends Node2D

var projectile_dict: Dictionary = {
	"player_cap":
}

func kill_all():
	for child in get_children():
		if (child is not Projectile):
			continue
		child.queue_free()


func _on_player_request_projectile(name: String, position: Vector2, extra: Dictionary) -> void:
	pass # Replace with function body.
