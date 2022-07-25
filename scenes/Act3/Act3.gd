extends Node2D

enum MapAreas {
	ForestPath,
	Cabin,
	Town,
	Villa
}

var death_allowed : bool = false
var dead : bool = false

var vin_min = 0.409
var vin_max = -1

var damage_per_second : float = 100 / 10.0

var hp = 100

var color_consumed : bool = false

var cabin_consume_time : float = 10.0
var forest_path_consume_time : float = 15.0
var town_consume_time : float = 15.0
var villa_consume_time : float = 15.0

var current_area : int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if dead:
		return
	
	color_consumed = _drain_current_area(delta)
	
	if color_consumed == false:
		hp -= damage_per_second * delta
	else:
		hp += damage_per_second *delta
	
	_check_health()
	_update_vignette()


func _check_health():
	if hp <= 0:
		_death()
	elif hp >= 100:
		hp = 100


func _death():
	dead = true
	
	if dead and not death_allowed:
		Game.change_scene("res://scenes/Act3/Act3.tscn")
	elif dead and death_allowed:
		pass #death ending


func _update_vignette():
	var new_vin = lerp(vin_max, vin_min, hp/100.0)
	$Player/CanvasLayer/Vignette.material.set_shader_param("multiplier", new_vin)


func _on_CabinArea_body_entered(body):
	if body.is_in_group("player"):
		current_area = MapAreas.Cabin


func _on_ForestPath_body_entered(body):
	if body.is_in_group("player"):
		current_area = MapAreas.ForestPath


func _on_Town_body_entered(body):
	if body.is_in_group("player"):
		current_area = MapAreas.Town


func _on_Villa_body_entered(body):
	if body.is_in_group("player"):
		current_area = MapAreas.Villa


func _drain_current_area(delta : float) -> bool:
	match(current_area):
		MapAreas.ForestPath:
			return _drain_texture($GroundLayer/ForestPath, $TopLayer/ForestPathStuffLayer, delta)
		
		MapAreas.Cabin:
			return _drain_texture($GroundLayer/Cabin, $TopLayer/Cabin, delta)
		
		MapAreas.Villa:
			return _drain_texture($GroundLayer/Villa, $TopLayer/Villa, delta)
		
		MapAreas.Town:
			return _drain_texture($GroundLayer/Town, $TopLayer/Town, delta)			
		
	return true


func _drain_texture(ground, top, delta) -> bool:
	if ground.modulate.a <= 0:
		return false
	ground.modulate.a -= delta / forest_path_consume_time
	top.modulate.a -= delta / forest_path_consume_time

	return true
