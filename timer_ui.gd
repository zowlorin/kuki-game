extends Control

func format_time(t):
	var min: int = floor(t / 60)
	var sec: int = int(t-min*60)
	
	return "%02d:%02d" % [min, sec]

@onready var known_time: float = 0:
	set(x):
		known_time = x
		$MainLabel.text = format_time(x)
		
func _on_game_timer_time_changed(value: float) -> void:
	known_time = value
	
