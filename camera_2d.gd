extends Camera2D


signal entered(focus: Node2D)
signal exited(focus: Node2D)

@onready var relevant: Array[Node2D] = []

@onready var current_focus: Node2D

@onready var player: Player = get_parent().get_node("Player")

func refresh_relevant():
	var cleaned: Array[Node2D] = []
	for node in relevant:
		if node:
			cleaned.append(node)
	relevant = cleaned
	
func _process(delta: float) -> void:
	if not current_focus:
		return
		
	if (current_focus is Path2D):
		var focus_path: Path2D = current_focus
		
		var path_player_pos: Vector2 = focus_path.to_local(player.global_position)
		var point: Vector2 = focus_path.curve.get_closest_point(path_player_pos)
		
		global_position = focus_path.to_global(point)
	
func set_focus(focus: Node2D):
	current_focus = focus

	if (focus is not Path2D):
		global_position = focus.global_position

func _on_level_handler_camera_area_entered(focus: Node2D) -> void:
	relevant.append(focus)
	set_focus(focus)
	refresh_relevant()

func _on_level_handler_camera_area_exited(focus: Node2D) -> void:
	relevant.erase(focus)
	refresh_relevant()
	
	if (!relevant.is_empty()):
		set_focus(relevant.back())

func _on_level_handler_level_setup_done() -> void:
	refresh_relevant()
