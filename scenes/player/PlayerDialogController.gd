extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("dialog_trigger", self, "_on_dialog_trigger")

func _on_dialog_trigger(index):
	$DialogRunner.run_dialog(index)
