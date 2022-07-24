extends Node2D

export(Array, Resource) var SFX_scenes

var _is_playing : bool = false
var _track_playing : OneShotAudio = null

signal started
signal completed

func play_sound(index : int):
	if not has_sound(index):
		return
	
	if _is_playing and _track_playing != null:
		_is_playing = false
		_track_playing.stop()
	
	var sfx_instance : OneShotAudio = SFX_scenes[index].instance()
	sfx_instance.connect("finished", self, "_on_sfx_complete")
	_track_playing = sfx_instance
	_is_playing = true
	add_child(sfx_instance)
	emit_signal("started")
	

func play_any():
	play_sound(rand_range(0, num_of_sounds()))

func num_of_sounds() -> int:
	return SFX_scenes.size()

func has_sound(index : int) -> bool:
	return index >= 0 and index < num_of_sounds()

func _on_sfx_complete() -> void:
	emit_signal("completed")
	_is_playing = false
	_track_playing = null
