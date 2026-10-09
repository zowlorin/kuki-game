extends StaticBody2D

class_name PlayerCap

@onready var offset: Vector2

@export var speed: float = 1000

@onready var velocity: Vector2 = Vector2.ZERO

@onready var active: bool = false:
	set(x):
		if (active==x):
			return
		active = x
		$CollisionShape2D.set_deferred("disabled", !x)
		$Hurtbox/CollisionShape2D.set_deferred("disabled", !x)
		visible = active
		if not active:
			velocity = Vector2.ZERO

@export var max_hits: int = 2
			
func deactivate():
	active = false
	hits = 0

@onready var hits: int = 0:
	set(x):
		hits = x
		if (hits >= max_hits):
			deactivate()
		
func _ready():
	active = false

func throw(position: Vector2, direction: float):
	global_position = position
	
	active = true
	
	velocity = Vector2.RIGHT * direction * speed
	
	hits = 0
	
func on_hurt():
	velocity.x *= -1
	
	hits += 1

func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta)


func _on_hurtbox_body_entered(body: Node2D) -> void:
	on_hurt()
