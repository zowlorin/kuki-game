extends Node

signal silenced(key: String)

# stores children for quick lookup
var _sounds: Dictionary = {}
# active tweens to prevent transition overlaps
var _tweens: Dictionary = {}

var _current_music: AudioStreamPlayer
var _queued_music: AudioStreamPlayer

@onready var music_delay: Timer = get_node_or_null("MusicDelay")


func _ready() -> void:
	_register_sound_nodes()
	if music_delay:
		music_delay.timeout.connect(_on_music_delay_timeout)


func _register_sound_nodes() -> void:
	for child in get_children():
		if child is AudioStreamPlayer:
			_sounds[child.name] = child
			_sounds[child.name.to_snake_case()] = child


# play sound with random pitch feature
# AudioManager.play("DashSFX") or AudioManager.play("dash_sfx", 0.9, 1.1)
func play(key: String, min_pitch: float = 1.0, max_pitch: float = 1.0) -> void:
	var sound: AudioStreamPlayer = _sounds.get(key)
	
	if not sound:
		push_warning("AudioManager: Sound key '%s' not found." % key)
		return
	
	if key.contains("Music"):
		_current_music = sound

	sound.pitch_scale = randf_range(min_pitch, max_pitch)
	sound.play()


# sound fade to silence transition
func fade_out(key: String, duration: float = 1.0) -> void:
	var sound: AudioStreamPlayer = _sounds.get(key)
	if not sound or not sound.playing:
		return

	_kill_tween(sound)

	var tween := create_tween()
	_tweens[sound] = tween
	
	tween.tween_property(sound, "volume_db", linear_to_db(0.001), duration)
	await tween.finished

	if sound.playing:
		sound.stop()
		sound.volume_db = 0.0  # Reset volume for future plays
	
	_tweens.erase(sound)
	silenced.emit(key)


# for linear audio
func change_volume(key: String, linear_volume: float, duration: float) -> void:
	var sound: AudioStreamPlayer = _sounds.get(key)
	if not sound:
		return

	_kill_tween(sound)

	var target_db := linear_to_db(maxf(linear_volume, 0.0001))
	
	if duration <= 0.0:
		sound.volume_db = target_db
		return

	var tween := create_tween()
	_tweens[sound] = tween
	tween.tween_property(sound, "volume_db", target_db, duration)


# called with delay to loop music
func _on_music_finished() -> void:
	music_delay.wait_time = randf_range(3.0, 10.0)
	music_delay.start()


func _on_music_delay_timeout() -> void:
	play(_current_music.name)


# stops tween to start a new one
func _kill_tween(sound: AudioStreamPlayer) -> void:
	if _tweens.has(sound) and is_instance_valid(_tweens[sound]):
		_tweens[sound].kill()
