extends Area2D

func _on_NextActTrigger_body_entered(body):
	if body.is_in_group("player"):
		Game.change_scene("res://scenes/Act2/Act2.tscn")
