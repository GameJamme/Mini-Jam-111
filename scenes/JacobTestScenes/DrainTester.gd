extends Node2D


onready var drainable : Drainable = $FullColor
var drain_radius = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	drainable.on_drain_tick(get_viewport().get_mouse_position(), drain_radius, delta)
