extends Node2D

@onready var curr_level = $Level

@onready var level_change_available: bool = false

@onready var level_queued: String

func connect_level(level: Level):
	level.connect("level_change_requested",_receive_level_change_request)
	
func queue_level(level_path: String):
	level_queued = level_path
	
func change_level(level_path: String):
	if (!level_change_available):
		queue_level(level_path)
		return
	
	if (!curr_level):
		printerr("Level change requested with no current level yet?")
	else:
		curr_level.queue_free()
		
		
	var new_level = load(level_path).instantiate()
	
	connect_level(new_level)
	add_child(new_level)
	
	curr_level = new_level
	level_queued = ""
	
	level_change_available = false
	$Timer.start()

func handle_queued_level():
	if (!level_queued):
		return
		
	change_level(level_queued)

func _receive_level_change_request(scene_path: String):
	change_level(scene_path)

func _ready() -> void:
	for child in get_children():
		if (child is not Level): continue
		connect_level(child)

func _on_timer_timeout() -> void:
	level_change_available = true
	handle_queued_level()
