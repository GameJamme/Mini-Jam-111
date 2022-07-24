extends Node

# Placeholder signal
signal basic_trigger




# Player Signals
signal dialog_trigger(index)
func on_dialog(index : int):
	emit_signal("dialog_trigger", index)

signal ground_type_changed(new_type)
func on_ground_type_changed(new_type : int):
	emit_signal("ground_type_changed", new_type)

# Music Signals
