class_name Drainable
extends Sprite

# We will need to store an alpha_bitmap image for each level of the game
# these will be modified during runtime and used to create textures that will 

var image_texture : ImageTexture = ImageTexture.new()
var alpha_bitmap : Image = Image.new()

export var _min_drain_time : float = 5.0
export var _max_drain_time : float = 10.0

export var _zero_distance_drain : float = 0.0 #drain 100% at close range
export var _max_distance_drain : float = 0.6 #drain only up to 60% at the edge

signal drained(amount)

# Given a sprite such as the tree tops layer - get an image that can be used to act as the alpha mask
# It's RGBA with only the R channel used to store the map
func _get_default_image_map(reference : Texture) -> Image:
	var image : Image =  Image.new()
	image.create(reference.get_width(), reference.get_height(),false,Image.FORMAT_RGB8)
	image.fill(Color(1,0,0,0))
	return image

# returns a pool of Vector3s that contain:
# x: x pos relative to player
# y: y position relative to player
# z: distance from the player
func _get_pixel_coords_around_player(player_pos : Vector2, image_size : Vector2, radius : int) -> PoolVector3Array:
	
	var coords : PoolVector3Array = PoolVector3Array()
	
	for x in range(player_pos.x - radius, player_pos.x + radius + 1):
		if x < 0 or x >= image_size.x:
			continue
		for y in range(player_pos.y - radius, player_pos.y + radius + 1):
			if y < 0 or y >= image_size.y:
				continue
			var relative_x = x - player_pos.x
			var relative_y = y - player_pos.y 
			var squared_distance = relative_x*relative_x + relative_y*relative_y;
			if(radius * radius >= squared_distance):
				coords.append(Vector3(x,y,sqrt(squared_distance)))
	
	return coords

# Given an image for a given level and the player position - drain the image and return 
# how many pixels had life to give
func _drain_image(image_map : Image, player_pos : Vector2, radius : int, time_delta : float) -> float:
	
	image_map.lock()
	
	var drained_color_sum : float = 0.0;
	var image_size : Vector2 = Vector2(image_map.get_width(), image_map.get_height())
	var coords_around_player : PoolVector3Array = _get_pixel_coords_around_player(player_pos, image_size, radius)
	
	for coord in coords_around_player:
		var pixel : Color = image_map.get_pixel(coord.x, coord.y)
		if(pixel.r > _get_max_drain_value_at_range(coord.z, radius)):
			var to_drain : float = _get_drain_value(pixel.r, coord.z, radius) * time_delta
			drained_color_sum += to_drain
			pixel.r -= to_drain
			image_map.set_pixel(coord.x, coord.y, pixel)
			if(pixel.r < 0):
				pixel.r = 0
	
	image_map.unlock()
	return drained_color_sum


func _get_max_drain_value_at_range(distance : float, max_range : float) -> float:
	return lerp(_zero_distance_drain, _max_distance_drain, distance/max_range)

func _get_drain_value(red_value : float, distance : float, max_distance : float) -> float:
	return lerp(1/_min_drain_time,1/_max_drain_time, distance/max_distance)

func _set_shader_texture(texture : ImageTexture, sprite : Sprite) -> void:
	sprite.material.set_shader_param("alpha_mask", texture)

func _update_image_texture():
	image_texture.create_from_image(alpha_bitmap)

# Called when the node enters the scene tree for the first time.
func _ready():
	alpha_bitmap = _get_default_image_map(self.texture)
	_update_image_texture()
	_set_shader_texture(image_texture, self)

func _map_global_coords_to_rect(rect_pos : Vector2, rect_size: Vector2, global_pos : Vector2):
	var local_pos = global_pos
	local_pos.x += rect_size.x / 2.0
	local_pos.y += rect_size.y / 2.0
	
	return local_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var localized_mouse_pos : Vector2 = _map_global_coords_to_rect(position, get_rect().size, get_local_mouse_position())
	var healing = _drain_image(alpha_bitmap, localized_mouse_pos, 100, delta)
	_update_image_texture()
	if(healing > 0):
		emit_signal("drained", healing)
