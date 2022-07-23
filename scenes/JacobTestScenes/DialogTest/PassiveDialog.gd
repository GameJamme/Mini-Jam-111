class_name PassiveDialog
extends Node2D

export(NodePath) var text_lable_path
onready var text_lable : Label = get_node(text_lable_path)

export(Array, String) var dialogs
export(float) var letter_time = 0.3
export(float) var hide_time = 5.0

export(bool) var random = false
export(float) var random_time_min = 3
export(float) var random_time_max = 12

var trigger_colliders : Array

var _current_dialog : String
var _screen_text : String
var _current_dialog_letter_index : int

var random_timer : Timer = Timer.new()
var hide_timer : Timer = Timer.new()

var _coroutine

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_child(random_timer)
	self.add_child(hide_timer)
	hide_timer.set_one_shot(true)
	random_timer.set_one_shot(true)
	
	hide_timer.connect("timeout", self, "_on_hide_timer_timeout")
	
	if not random:
		return
	
	random_timer.connect("timeout", self, "_on_random_timer_timeout")
	random_timer.start(_get_random_time())


func _get_random_time() -> float:
	return rand_range(random_time_min, random_time_max)


func _on_random_timer_timeout():
	run_dialog(rand_range(0,dialogs.size()))


# Triggers the dialog at the given dialogs index
func run_dialog(dialog_index : int):
	if not has_dialog(dialog_index):
		return
	
	_current_dialog = dialogs[dialog_index]
	_screen_text = ""
	
	_coroutine = _run_dialog_coroutine()


func has_dialog(dialog_index : int) -> bool:
	return dialog_index >= 0 or dialog_index < num_of_dialogs()


func num_of_dialogs() -> int:
	return dialogs.size()


func _run_dialog_coroutine():
	for letter in _current_dialog:
		_screen_text += letter
		_set_text("\"" + _screen_text + "\"")
		yield(get_tree().create_timer(letter_time), "timeout")
	
	hide_timer.start(hide_time)


func _on_hide_timer_timeout():
	_set_text("")
	if random:
		random_timer.start(_get_random_time())


func _set_text(text : String):
	text_lable.text = text
