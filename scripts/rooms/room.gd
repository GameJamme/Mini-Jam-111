extends Area2D

onready var collision: CollisionShape2D = $CollisionShape2D


func update_bounds(body):
	if body.is_in_group("player"):
		var cam: Camera2D = body.get_node("Camera2D")
		
		var global_x = global_position.x
		var global_y = global_position.y
		var shape = collision.shape.extents
		
		cam.limit_left = global_x - shape.x
		cam.limit_right = global_x + shape.x
		cam.limit_bottom = global_y + shape.y
		cam.limit_top = global_y - shape.y


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if not body.initial_area:
			body.initial_area = self
			update_bounds(body)
#		elif not body.next_area:
		body.next_area = self


func _on_Area2D_body_exited(body):
	if body.is_in_group("player") and body.next_area:
		body.current_area = body.next_area
		if body.current_area:
			body.current_area.update_bounds(body)
		body.next_area = null
		
