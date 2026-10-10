extends StaticBody2D



@export var trigger_mech: TriggerMech

@onready var blocked: bool = true:
	set(x):
		blocked = x
		$CollisionShape2D.set_deferred("disabled", !blocked)

func on_open():
	AudioManager.play("DoorSFX")
	$AnimationPlayer.play("Open")
	blocked = false

func on_close():
	AudioManager.play("DoorSFX")
	$AnimationPlayer.play("Close")
	blocked = true
	
@onready var open: bool = false:
	set(x):
		if (x and not open):
			on_open()
		if (!x and open):
			on_close()
		open = x
		
@onready var cooling: bool = false

@onready var queued_actions: Array = []

func on_trigger(active: bool):
	if (cooling):
		queued_actions.append(active)
		return
		
	open = active
	$Timer.start()

func _ready() -> void:
	if (!trigger_mech):
		return
		
	trigger_mech.connect("on_triggered", on_trigger)


func _on_timer_timeout() -> void:
	cooling = false
	
	if (queued_actions.is_empty()):
		return
		
	open = queued_actions[0]
	queued_actions.pop_front()
	
	cooling = true
	
	$Timer.start()
