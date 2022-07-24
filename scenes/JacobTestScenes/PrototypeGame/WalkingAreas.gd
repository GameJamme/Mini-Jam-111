extends Node2D

var current_type : int = 1

func _on_StoneArea_body_entered(body):
	if _body_not_player(body):
		return
	current_type = FootstepManager.GroundType.stone
	SignalBus.emit_signal("ground_type_changed", current_type)


func _on_StoneArea_body_exited(body):
	if _body_not_player(body):
		return
	if current_type == FootstepManager.GroundType.stone:
		_default_to_grass()


func _on_WoodArea_body_entered(body):
	if _body_not_player(body):
		return
	current_type = FootstepManager.GroundType.wood
	SignalBus.emit_signal("ground_type_changed", current_type)


func _on_WoodArea_body_exited(body):
	if _body_not_player(body):
		return
	if current_type == FootstepManager.GroundType.wood:
		_default_to_grass()


func _default_to_grass():
	current_type = FootstepManager.GroundType.grass
	SignalBus.emit_signal("ground_type_changed", current_type)


func _body_not_player(body) -> bool:
	return not body.is_in_group("player")
