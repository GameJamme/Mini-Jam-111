extends Node2D


signal type_changed(type)

var current_type : int = 1

func _on_StoneArea_body_entered(body):
	if _body_not_player(body):
		return
	current_type = FootstepManager.GroundType.stone
	emit_signal("type_changed", current_type)


func _on_StoneArea_body_exited(body):
	if _body_not_player(body):
		return
	if current_type == FootstepManager.GroundType.stone:
		_default_to_grass()


func _on_WoodArea_body_entered(body):
	if _body_not_player(body):
		return
	current_type = FootstepManager.GroundType.wood
	emit_signal("type_changed", current_type)


func _on_WoodArea_body_exited(body):
	if _body_not_player(body):
		return
	if current_type == FootstepManager.GroundType.wood:
		_default_to_grass()


func _default_to_grass():
	current_type = FootstepManager.GroundType.grass
	emit_signal("type_changed", current_type)


func _body_not_player(body) -> bool:
	return not body.is_in_group("player")
