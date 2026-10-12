extends StaticBody2D



@export var trigger_mech: TriggerMech
@export var inverted: bool = false

@onready var blocked: bool = !inverted:
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
	
@onready var open: bool = inverted:
	set(x):
		if (x and not open):
			on_open()
		if (!x and open):
			on_close()
		open = x
		
@onready var cooling: bool = false

@onready var queued_actions: Array = []

func on_trigger(active: bool):
	var target_state = !active if inverted else active
	if (cooling):
		queued_actions.append(target_state)
		return
		
	open = target_state
	$Timer.start()

func _ready() -> void:
	if inverted:
		$AnimationPlayer.play("Open")
		$AnimationPlayer.seek($AnimationPlayer.get_animation("Open").length, true)
		
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
