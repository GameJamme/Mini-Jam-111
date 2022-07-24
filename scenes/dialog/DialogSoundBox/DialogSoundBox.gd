class_name DialogSoundBox
extends Node2D

export(Array, String) var dialogs
export(float) var letter_time = 0.3
export(float) var hide_time = 5.0

export(bool) var random = false
var random_timer : Timer = Timer.new()
export(float) var random_time_min = 3
export(float) var random_time_max = 12


export(Array, Resource) var SFX_scenes

var sfx_running : bool = false
var dialog_running : bool = false

func _ready():
	# Init Dialog runner
	$DialogRunner.dialogs = dialogs
	$DialogRunner.letter_time = letter_time
	$DialogRunner.hide_time = hide_time
	$DialogRunner.random = false
	
	$SoundBox.SFX_scenes = SFX_scenes
	
	$SoundBox.connect("completed", self, "_on_sfx_completed")
	$DialogRunner.connect("dialog_completed", self, "_on_dialog_completed")
	
	if random:
		random_timer.connect("timeout", self, "_on_random_timer_timeout")
		add_child(random_timer)
		random_timer.start(rand_range(random_time_min, random_time_max))


func play_any() -> void:
	var index = rand_range(0,max(dialogs.size(),SFX_scenes.size()))
	play(index)


func play(index : int) ->void:
	$DialogRunner.run_dialog(index)
	if $DialogRunner.has_dialog(index):
		dialog_running = true
	$SoundBox.play_sound(index)
	if $SoundBox.has_sound(index):
		sfx_running = true


func _on_random_timer_timeout() -> void:
	play_any()


func _try_play_random():
	if random and not dialog_running and not sfx_running:
		random_timer.start(rand_range(random_time_min, random_time_max))


func _on_sfx_completed() -> void:
	sfx_running = false
	_try_play_random()


func _on_dialog_completed() -> void:
	dialog_running = false
	_try_play_random()
