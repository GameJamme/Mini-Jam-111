extends KinematicBody2D

export(int) var move_speed = 250
var direction
var current_area = null
var next_area = null
var initial_area = null

func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	direction = direction.normalized() * move_speed
	direction = move_and_slide(direction, Vector2.UP)
