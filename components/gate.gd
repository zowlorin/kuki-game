extends StaticBody2D

@export var trigger_mech: TriggerMech

@onready var blocked: bool = true:
	set(x):
		blocked = x
		$CollisionShape2D.disabled = !blocked

func on_open():
	$AnimationPlayer.play("Open")
	blocked = false

func on_close():
	$AnimationPlayer.play("Close")
	blocked = true
	
@onready var open: bool = false:
	set(x):
		if (x and not open):
			on_open()
		if (!x and open):
			on_close()
		open = x
		

func on_trigger(active: bool):
	open = active

func _ready() -> void:
	if (!trigger_mech):
		return
		
	trigger_mech.connect("on_triggered", on_trigger)
