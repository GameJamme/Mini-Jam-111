class_name FootstepManager
extends Node2D

enum GroundType {
	wood,
	stone,
	grass
}

var current_type : int = 1


func on_step():
	_step_sound(current_type)


func _step_sound(type : int):
	match(type):
		GroundType.grass:
			$GrassFootsteps.play_any()
		GroundType.wood:
			$WoodFootsteps.play_any()
		GroundType.stone:
			$StoneFootsteps.play_any()


func _on_WalkingAreas_type_changed(type):
	current_type = type
