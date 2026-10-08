extends Node2D

signal zone_changed(zone: SafeZone)

func on_zone_enter(zone: SafeZone):
	zone_changed.emit(zone)
	
	print(zone)

func _ready():
	var placeholder_zone: SafeZone
	
	for child in get_children():
		if (child is not SafeZone):
			continue
		child.connect("player_entered", on_zone_enter)
		placeholder_zone = child
		
	if not placeholder_zone:
		printerr("No placeholder zone found?")
		return
		
	zone_changed.emit(placeholder_zone)
