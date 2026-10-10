extends TriggerMech

class_name Mirror

@export var mirrored_limit: int = 1

@onready var mirrors : Array[CharacterBody2D] = []
@onready var player_scene = preload("res://gameplay/player.tscn")

func _physics_process(delta: float) -> void:
	if player_interacting and Input.is_action_just_pressed("interact"):
		AudioManager.play("MirrorSFX")
		if mirrors.size() >= mirrored_limit:
			var mirror = mirrors.pop_back()
			mirror.call_deferred("queue_free")
			return
		
		var distance = target.global_position - global_position
		var mirrored_player : CharacterBody2D = player_scene.instantiate()
		mirrored_player.set_collision_layer_value(2, false)
		mirrored_player.set_collision_layer_value(4, true)
		mirrored_player.mirrored = true
		
		mirrored_player.global_position.x = -distance.x + global_position.x
		mirrored_player.global_position.y = target.global_position.y
		
		owner.add_child(mirrored_player)
		mirrors.append(mirrored_player)
	
