extends Area2D


var already_triggered : bool = false
export var dialog_index : int = -1

func _ready():
	connect("body_entered", self, "_trigger")


func _trigger(body):
	if already_triggered or not body.is_in_group("player"):
		return
	
	already_triggered = true
	SignalBus.emit_signal("dialog_trigger", dialog_index)
