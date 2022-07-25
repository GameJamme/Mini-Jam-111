extends Area2D


var triggered : bool = false

signal start_encounter

func _on_StartEncounter_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("start_encounter")
