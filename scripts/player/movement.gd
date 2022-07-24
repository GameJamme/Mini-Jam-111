extends KinematicBody2D

export(int) var move_speed = 250
var direction
var current_area = null
var next_area = null
var initial_area = null

var moving : bool = false
var animating : bool = false

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")

func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	direction = direction.normalized() * move_speed
	direction = move_and_slide(direction, Vector2.UP)
	moving = direction.length_squared() > 0
	if(!animating and moving):
		_animate()
		pass


func _animate():
	$AnimationPlayer.play("WobbleAnimation")


func _on_animation_finished(name):
	if name != "WobbleAnimation":
		return
	
	if moving:
		_animate()
	else:
		animating = false
