extends Node2D


func _on_VibrantMeadow_body_entered(body):
	if not body.is_in_group("player"):
		return
	MusicPlayerManager.start("VibrantMeadow")


func _on_VibrantMeadowCursed_body_entered(body):
	if not body.is_in_group("player"):
		return
	MusicPlayerManager.start("VibrantMeadowCursed")


func _on_TownSquare_body_entered(body):
	if not body.is_in_group("player"):
		return
	MusicPlayerManager.start("TownSquare")


func _on_VibrantMeadowCursedGuitar_body_entered(body):
	if not body.is_in_group("player"):
		return
	MusicPlayerManager.start("VibrantMeadowCursedGuitar")
