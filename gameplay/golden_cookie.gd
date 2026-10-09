extends Area2D

class_name GoldenCookie

@export var id: int = 100

@onready var enabled: bool = false:
	set(x):
		if (enabled==x):
			return
		$CollisionShape2D.disabled=!enabled
		visible=enabled
		
signal collected(id: int)

@onready var cookie_handler: Node2D = get_tree().current_scene.get_node("Handlers/CookieCollectHandler")
		
func _ready():
	if cookie_handler.is_collected(id):
		enabled = false
		visible = false
	
func on_collect():
	if cookie_handler.is_collected(id):
		return
	collected.emit(id)
	enabled = false
	visible = false

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
