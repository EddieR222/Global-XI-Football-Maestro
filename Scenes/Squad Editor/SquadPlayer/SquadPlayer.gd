extends VBoxContainer

var player: Player;
var relative_position: Vector2;

signal squad_player_swapped(at_position: Vector2, data)

func _get_drag_data(at_position: Vector2) -> Control:
	# We are getting a duplicate of this node
	var copy_node: Control = self.duplicate();
	
	## This centers the drag preview around mouse (instead of the top left corner)
	var c: Control = Control.new()
	##c.global_position = copy_node.global_position
	copy_node.position = -0.5 * copy_node.size
	
	#CRITICAL make sure to leave this in, took me a day of debugging to find this, drag previews need to not be top level so they aren't stuck when encountering other top levels
	copy_node.top_level = false
	
	c.add_child(copy_node)

	# Pass in this duplicate so the drag preview is this entire scene
	set_drag_preview(c)
	
	#c.position = Vector2(0,0)

	# And now we want to return the duplicate
	return self
	

func _can_drop_data(at_position: Vector2, data) -> bool:
	# Check position if it is relevant to you
	return true
	
func _drop_data(at_position: Vector2, data):
	var global_at_position: Vector2 = self.get_global_rect().position + at_position
	squad_player_swapped.emit(global_at_position, data);




	
func set_player(p: Player) -> bool:
	player = p;
	
	get_tree().call_group("Squad_Info", "display_player", p)
	return true


""" Static Functions """
## This converts the relative positions to global positions and also accounting for center to top_left conversion
static func convert_relative_to_global(relative: Vector2, global_rect: Rect2) -> Vector2:
	var rect_size: Vector2 = global_rect.size;
	# Get ratio with size
	var relative_ratio: Vector2 = Vector2(roundi(float(relative.x) * (float(rect_size.x)/100.0)), roundi(float(relative.y) * (float(rect_size.y)/100.0)));
	var global_center: = global_rect.position + relative_ratio;
	
	# Now convert to center position, we do this by subtract half x and y
	global_center -= 0.5 * Vector2(125, 100)
	
	return global_center

static func convert_global_to_relative(global_pos: Vector2 , global_rect: Rect2) -> Vector2:
	
	var relative_pos: Vector2 = global_pos - global_rect.position;
	
	# Now we get ratio
	var rect_size: Vector2 = global_rect.size;
	var relative_ratio: Vector2 = Vector2(roundi((relative_pos.x/rect_size.x) * 100.0), roundi((relative_pos.y/rect_size.y) * 100.0))
	
	return relative_ratio; 
	
