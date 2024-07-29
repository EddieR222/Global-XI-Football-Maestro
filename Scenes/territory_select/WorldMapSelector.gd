extends Control

var color_map: Dictionary;
var img: Image;
var camera: Camera2D;


# Zoom factors
const ZOOM_FACTOR = 0.5
const MIN_ZOOM = 0.1
const MAX_ZOOM = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	load_country_info();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_just_released("Click"):
		#print(get_viewport().get_mouse_position());
		#var mouse_pos: Vector2 = get_viewport().get_mouse_position();
		##var adjusted_mouse_pos: Vector2i = Vector2i(mouse_pos / get_viewport().size())
		#var pixel_color: Color = img.get_pixel(mouse_pos.x as int, mouse_pos.y as int)
		#var correct_color: Color = Color(pixel_color.r, pixel_color.g, pixel_color.b)
		#var index:Vector3i = Vector3i(pixel_color.r * 255 as int, pixel_color.g * 255 as int , pixel_color.b*255 as int)
		#
		
		#var terr: Territory = color_map[index];
		#print(terr.Name)
	pass
		
func _input(event):
   # Mouse in viewport coordinates.
	var mouse_pos: Vector2
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				mouse_pos = get_global_mouse_position();   #event.position
				var viewport_dimensions: Vector2 = get_viewport().get_visible_rect().size# * camera.zoom
				var pos: Vector2i = Vector2i((mouse_pos.x / viewport_dimensions.x) * img.get_width() as int, (mouse_pos.y / viewport_dimensions.y) * img.get_height() as int)
				#var pos: Vector2i = Vector2i(get_global_mouse_position());
				print(pos)
				var pixel_color: Color = img.get_pixel(pos.x, pos.y);
				var correct_color: Color = Color(pixel_color.r, pixel_color.g, pixel_color.b)
				var index:Vector3i = Vector3i(pixel_color.r * 255 as int, pixel_color.g * 255 as int , pixel_color.b*255 as int)
				
				if index != Vector3i(0,0,0) and index != Vector3i(65,135,145) and index!= Vector3i(255,255,255):
					var terr: Territory = color_map[index];
					print(terr.Name)
			MOUSE_BUTTON_WHEEL_UP:
				# Zoom in
				camera.zoom += Vector2(ZOOM_FACTOR, ZOOM_FACTOR)
				camera.zoom.x = clamp(camera.zoom.x, MIN_ZOOM, MAX_ZOOM)
				camera.zoom.y = clamp(camera.zoom.y, MIN_ZOOM, MAX_ZOOM)
				camera.position = get_global_mouse_position();
				
			MOUSE_BUTTON_WHEEL_DOWN:
				# Zoom out
				camera.zoom -= Vector2(ZOOM_FACTOR, ZOOM_FACTOR)
				camera.zoom.x = clamp(camera.zoom.x, MIN_ZOOM, MAX_ZOOM)
				camera.zoom.y = clamp(camera.zoom.y, MIN_ZOOM, MAX_ZOOM)
				camera.position = get_global_mouse_position();
			MOUSE_BUTTON_MIDDLE:
				camera.position = get_global_mouse_position();
		
	#elif event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position)
	
func get_pixel_color_regions() -> Dictionary:
	var pixel_color_regions: Dictionary = {};
	for y in range(img.get_height()):
		for x in range(img.get_width()):
			var pixel_color: Color = img.get_pixel(x, y);
			var correct_color: Color = Color(pixel_color.r, pixel_color.g, pixel_color.b)
			var index:Vector3i = Vector3i(pixel_color.r * 255 as int, pixel_color.g * 255 as int , pixel_color.b*255 as int)
			if index not in pixel_color_regions:
				pixel_color_regions[index] = [];
			if index != Vector3i(0,0,0) and index != Vector3i(65,135,145) and index!= Vector3i(255,255,255):
				pixel_color_regions[index].append(Vector2(x, y));
	
	return pixel_color_regions
			
func get_polygons(region_color: Vector3i, pixel_color_dict: Dictionary):
	if region_color not in pixel_color_dict:
		return
	var targetImage = Image.create(img.get_size().x, img.get_size().y, false, Image.FORMAT_RGBA8);
	for value in pixel_color_dict[region_color]:
		targetImage.set_pixel(value.x, value.y, "#FFFFFF");
		
	var bitmap := BitMap.new();
	bitmap.create_from_image_alpha(targetImage);
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0,0), bitmap.get_size()), 0.1)
	return polygons
	
func load_country_info() -> void:
	# Load Color Info
	var gm_manager: GameMapManager = GameMapManager.new();
	color_map = gm_manager.get_map_info();
	
	# Load image pixel data
	img = get_node("TextureRect").get_texture().get_image()
	img.resize(get_viewport().get_visible_rect().size.x, get_viewport().get_visible_rect().size.y )
	
	# Load Camera
	camera = get_node("Camera2D");
	
	
	# Load Regions Areas
	var pixel_color_dict: Dictionary = get_pixel_color_regions();
	for region_color: Vector3i in color_map.keys():
		# Load scene and set variables
		var region = load("res://Scenes/territory_select/territory_area/RegionArea.tscn").instantiate()
		region.territory = color_map[region_color];
		region.set_name(region.territory.Name);
		get_node("Regions").add_child(region);
		
		var polygons = get_polygons(region_color, pixel_color_dict);
		if polygons == null:
			continue
		for polygon in polygons:
			var region_collision = CollisionPolygon2D.new();
			var region_polygon = Polygon2D.new();
			
			region_collision.polygon = polygon
			region_polygon.polygon = polygon
			
			region.add_child(region_collision);
			region.add_child(region_polygon);
		
		
		
		
		
	
	
	
	
