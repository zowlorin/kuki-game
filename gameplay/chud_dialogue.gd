extends Node2D

@onready var chud: Chud = get_parent()

@onready var label: Label = get_node("PanelContainer/MarginContainer/Label")

func _ready() -> void:
	visible = false
	label.text = ""

func on_interact():
	visible = true
	
	var target_text: String = "Get that cookie over there for me will you?"
	var tween = create_tween()
	
	label.visible_characters = 0
	label.text = target_text
	
	tween.tween_property(label, "visible_characters", label.get_total_character_count(), 1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and chud.player_interacting:
		on_interact()
