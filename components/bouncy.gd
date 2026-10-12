extends StaticBody2D

@export var allow_horizontal_bounce: bool = false

func _ready() -> void:
	self.add_to_group("Bouncy")

func _physics_process(_delta: float) -> void:
	if allow_horizontal_bounce:
		return
	
	if not $TriggerMech.player_interacting:
		$AnimatedSprite2D.play("untouched")

func _on_trigger_mech_hit() -> void:
	$AnimatedSprite2D.play("bouncing")
