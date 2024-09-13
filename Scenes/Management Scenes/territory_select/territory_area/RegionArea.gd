extends Area2D

## The Territory that this Area is respresenting
var territory: Territory;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func _on_mouse_entered():
	print(territory.Name) 
	for node in get_children():
		if node.is_class("Polygon2D"):
			
			node.modulate = Color(0.2,1,0.2,1)


func _on_input_event(viewport, event, shape_idx):
	var mouse_pos: Vector2
	#if event is InputEventMouseButton and event.is_pressed():
		#match event.button_index:
			#MOUSE_BUTTON_LEFT:
				#mouse_pos = get_global_mouse_position();   #event.position
				#var viewport_dimensions: Vector2 = get_viewport().get_visible_rect().size# * camera.zoom
				#var pos: Vector2i = Vector2i((mouse_pos.x / viewport_dimensions.x) * img.get_width() as int, (mouse_pos.y / viewport_dimensions.y) * img.get_height() as int)
				##var pos: Vector2i = Vector2i(get_global_mouse_position());
				#print(pos)
				#var pixel_color: Color = img.get_pixel(pos.x, pos.y);
				#var correct_color: Color = Color(pixel_color.r, pixel_color.g, pixel_color.b)
				#var index:Vector3i = Vector3i(pixel_color.r * 255 as int, pixel_color.g * 255 as int , pixel_color.b*255 as int)
				#
				#if index != Vector3i(0,0,0) and index != Vector3i(65,135,145) and index!= Vector3i(255,255,255):
					#var terr: Territory = color_map[index];
					#print(terr.Name)
			#MOUSE_BUTTON_WHEEL_UP:
				## Zoom in
				#camera.zoom += Vector2(ZOOM_FACTOR, ZOOM_FACTOR)
				#camera.zoom.x = clamp(camera.zoom.x, MIN_ZOOM, MAX_ZOOM)
				#camera.zoom.y = clamp(camera.zoom.y, MIN_ZOOM, MAX_ZOOM)
				#camera.position = get_global_mouse_position();
				#
			#MOUSE_BUTTON_WHEEL_DOWN:
				## Zoom out
				#camera.zoom -= Vector2(ZOOM_FACTOR, ZOOM_FACTOR)
				#camera.zoom.x = clamp(camera.zoom.x, MIN_ZOOM, MAX_ZOOM)
				#camera.zoom.y = clamp(camera.zoom.y, MIN_ZOOM, MAX_ZOOM)
				#camera.position = get_global_mouse_position();
			#MOUSE_BUTTON_MIDDLE:
				#camera.position = get_global_mouse_position();


func _on_mouse_exited():
	for node in get_children():
		if node.is_class("Polygon2D"):
			
			node.modulate = Color(1,1,1,1)
