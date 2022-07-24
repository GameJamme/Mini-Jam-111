class_name MusicPlayer
extends Node

export(Dictionary) var tracks : Dictionary

export(float) var blend_time : float = 3.0
export(float) var low_db : float = -50
var current_music : AudioStreamPlayer = null
var next_music : AudioStreamPlayer = null

var current_tween : Tween = Tween.new()
var next_tween : Tween = Tween.new()
var current_tween_complete : bool = true
var next_tween_complete : bool = true

func _ready():
	current_tween.connect("tween_completed", self, "_on_current_tween_complete")
	next_tween.connect("tween_completed", self, "_on_next_tween_complete")
	
	add_child(current_tween)
	add_child(next_tween)
	
	#testing
	#start("VibrantMeadow")
	#yield(get_tree().create_timer(10), "timeout")
	#start("TownSquare")
	#yield(get_tree().create_timer(10), "timeout")
	#start("VibrantMeadow")


func start(track_name : String):	
	if not tracks.has(track_name):
		return
	
	#force the blend to complete so we can start a new one
	if not next_tween_complete or not current_tween_complete:
		next_tween_complete = true
		current_tween_complete = true
		_try_finish_blend()
	
	next_music = tracks.get(track_name).instance()
	next_music.volume_db = low_db
	add_child(next_music)
	_blend()


func start_no_blend(track_name : String):
	if not tracks.has(track_name):
		return
	
	#force the blend to complete so we can start a new one
	if not next_tween_complete or not current_tween_complete:
		next_tween_complete = true
		current_tween_complete = true
		_try_finish_blend()
	
	if current_music != null:
		current_music.queue_free()
	current_music = tracks.get(track_name).instance()
	add_child(current_music)

func _blend():
	if current_music != null:
		current_tween.interpolate_property(current_music, "volume_db",
			current_music.volume_db, low_db, blend_time)
		current_tween.start()
		current_tween_complete = false
	
	if next_music != null:
		next_tween.interpolate_property(next_music, "volume_db",
			next_music.volume_db, 0, blend_time)
		next_tween.start()
		next_tween_complete = false


func stop():
	if is_playing():
		current_music.queue_free()
		current_music = null


func is_playing() -> bool:
	return current_music != null


func _try_finish_blend():
	if next_tween_complete and current_tween_complete:
		if current_music != null:
			current_music.queue_free()
		current_music = next_music
		next_music = null


func _on_next_tween_complete(_object: Object, _key: NodePath):
	if next_tween_complete:
		return
	next_tween_complete = true
	_try_finish_blend()


func _on_current_tween_complete(_object: Object, _key: NodePath):
	if current_tween_complete:
		return
	current_tween_complete = true
	_try_finish_blend()
