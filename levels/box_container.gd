extends TriggerMech

@onready var box_scene = preload("res://components/box.tscn")

@onready var box: RigidBody2D

func _ready() -> void:
	box = box_scene.instantiate()
	box.position = Vector2.ZERO
	box.set_name("Box")
	add_child(box)

func _physics_process(delta: float) -> void:
	if player_interacting and Input.is_action_just_pressed("interact"):
		var new_box = box_scene.instantiate()
		new_box.position = Vector2.ZERO
		new_box.set_name("Box")
		
		box.call_deferred("queue_free")
		box = new_box
		self.call_deferred("add_child", box)
