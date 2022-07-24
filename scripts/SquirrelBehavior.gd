extends Sprite

enum State {
	idle,
	walking
}

enum Direction {
	right = 1,
	left = -1
}

var last_walked : int = Direction.left
var facing : int = Direction.left
var state : int = State.idle

export(int) var steps : int = 3

export(float) var step_length : float = 1.0
export(float) var arc_height : float = 1.0

export(float) var step_time : float = 0.3
export(float) var step_delay : float = 0.3

export(float) var idle_time : float = 4
export(float) var idle_flip_min : float = 0.3
export(float) var idle_flip_max : float = 1

var y_tween : Tween = Tween.new()
var x_tween : Tween = Tween.new()

var y_going_up : bool = false
var y_start : float

var _walk_coroutine = null

var idle_timer : Timer = Timer.new()

signal walk_complete
signal idle_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(x_tween)
	add_child(y_tween)
	add_child(idle_timer)
	idle_timer.connect("timeout", self, "_on_idle_timer_timeout")
	y_start = position.y
	
	_state_loop()


func _state_loop():
	if(state == State.walking):
		var direction_to_walk = Direction.right if last_walked == Direction.left else Direction.left
		last_walked = direction_to_walk
		_walk(direction_to_walk)
	else:
		_idle()


func _walk(direction : int) -> void:
	if(direction != facing):
		_flip_sprite()
	
	for x in steps:
		_step(direction)
		yield(x_tween, "tween_completed")
		yield(get_tree().create_timer(step_delay), "timeout")
		x_tween.stop_all()
		y_tween.stop_all()
	
	_change_state()
	emit_signal("walk_complete")
	_state_loop()


func _step(direction : int):
	x_tween.interpolate_property(self, "position:x", position.x, 
				position.x + direction * step_length, step_time)
		
	y_tween.interpolate_property(self, "position:y", y_start, 
			y_start - arc_height / 2.0, step_time / 2.0, Tween.TRANS_CIRC)
	y_going_up = true
	
	x_tween.start()
	y_tween.start()
	
	yield(y_tween, "tween_completed")
	
	y_tween.interpolate_property(self, "position:y", y_start, 
			y_start + arc_height, step_time / 2.0)
	
	y_tween.start()


func _idle() -> void:
	
	if idle_timer.is_stopped():
		idle_timer.start(idle_time)
	
	var wait_time : float = rand_range(idle_flip_min,idle_flip_max)
	yield(get_tree().create_timer(wait_time), "timeout")
	
	_flip_sprite()
	_state_loop()


func _flip_sprite():
	facing = Direction.left if facing == Direction.right else Direction.right
	flip_h = not flip_h


func _change_state():
	state = State.walking if state == State.idle else State.idle


func _on_idle_timer_timeout():
	_change_state()
