extends Control

func _ready() -> void:
	$Label.visible = false


func _on_level_handler_level_loaded(title: String) -> void:
	if (title.strip_edges().length()==0):
		return
	$Label.text = title
	$AnimationPlayer.play("Main")
