extends Node2D


signal type_changed(type)

var current_type : int = 1


func _ready():
	_on_StoneArea_body_entered(null)

func _on_StoneArea_body_entered(body):
	current_type = FootstepManager.GroundType.stone
	emit_signal("type_changed", current_type)


func _on_StoneArea_body_exited(body):
	if current_type == FootstepManager.GroundType.stone:
		_default_to_grass()


func _on_WoodArea_body_entered(body):
	if current_type == FootstepManager.GroundType.stone: return
	current_type = FootstepManager.GroundType.wood
	emit_signal("type_changed", current_type)


func _on_WoodArea_body_exited(body):
	if current_type == FootstepManager.GroundType.wood:
		_default_to_grass()


func _default_to_grass():
	current_type = FootstepManager.GroundType.grass
	emit_signal("type_changed", current_type)
