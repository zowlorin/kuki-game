extends Node2D

signal level_okay
signal level_setup_done

signal respawn_target_changed(target: SafeZone)

@onready var curr_level: Level

@export_file_path("*.tscn") var initial_level: String
@export var initial_portal: String = "a1"


@onready var level_change_available: bool = false

@onready var level_queued: Dictionary

@onready var player: Player = get_parent().get_parent().get_node("Player")

@onready var cold_start_done: bool = false

func on_respawn_target_changed(target: SafeZone):
	respawn_target_changed.emit(target)
func connect_level(level: Level):
	level.connect("level_change_requested",_receive_level_change_request)
	level.connect("respawn_target_changed",on_respawn_target_changed)
	
func queue_level(level_path: String, target_id: String):
	level_queued = {"level": level_path, "target_id": target_id}
	
func change_level(level_path: String, target_id: String):
	if (!level_change_available):
		queue_level(level_path, target_id)
		return
	
	for child in get_children():
		if (child is not Level): continue
		child.queue_free()
		
	var new_level = load(level_path).instantiate()
	
	connect_level(new_level)
	add_child(new_level)
	
	var portals = new_level.get_node("PortalHandler").get_children()
	
	var target_portal: Portal
	
	for portal in portals:
		if (portal.id == target_id):
			target_portal = portal
			break

	curr_level = new_level
	level_queued = {}
	
	level_change_available = false
	$Timer.start()
		
	if not target_portal:
		print("wtf u didnt set it correctly")
		return
	
	player.global_position = target_portal.global_position
	level_setup_done.emit()

func handle_queued_level():
	if (!level_queued):
		return
		
	change_level(level_queued["level"], level_queued["target_id"])

func _receive_level_change_request(scene_path: String, target_id: String):
	change_level(scene_path, target_id)

func _ready() -> void:
	for child in get_children():
		if (child is not Level): continue
		child.queue_free()
		
	change_level(initial_level, initial_portal)
	
	for child in get_children():
		if (child is not Level): continue
		connect_level(child)

func _on_timer_timeout() -> void:
	level_change_available = true
	handle_queued_level()

func _on_level_setup_done() -> void:
	if (cold_start_done):
		return
		
	cold_start_done = true
	level_okay.emit()
