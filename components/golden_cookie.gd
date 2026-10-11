extends Area2D

class_name GoldenCookie

@onready var id = owner.level_id

@onready var enabled: bool = false:
	set(x):
		if (enabled==x):
			return
		$CollisionShape2D.set_deferred("disabled", !x)
		visible=x
		
signal collected(id: int)

@onready var cookie_handler: Node2D = get_tree().current_scene.get_node("Handlers/CookieCollectHandler")
		
func _ready():
	if cookie_handler.is_collected(id):
		enabled = false
		visible = false

func on_collect():
	if cookie_handler.is_collected(id):
		return
	AudioManager.play("CollectSFX", 0.9, 1.1)
	collected.emit(id)
	enabled = false
	visible = false

func on_dropped(id):
	if cookie_handler.is_fed(id):
		return
	enabled = true
	visible = true

func _on_body_entered(body: Node2D) -> void:
	if (body is not Player):
		return
	on_collect()
	
func _process(delta: float) -> void:
	if (!enabled):
		return
	if cookie_handler.is_collected(id):
		enabled = false
		visible = false
