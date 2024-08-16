extends TabContainer


var squad: Array[VBoxContainer];
var subs: Array[VBoxContainer];

@onready var field_texture: TextureRect = get_node("Formation/TeamFormationDetails/TeamFormation/FieldandSquad/Field");
@onready var field: HBoxContainer = get_node("Formation/TeamFormationDetails/TeamFormation/FieldandSquad/MarginContainer/HBoxContainer");
@onready var sub_area: GridContainer = get_node("Formation/TeamFormationDetails/TeamFormation/SubsArea/ScrollContainer/SubArea")

@onready var formations: DefaultFormations = DefaultFormations.new()

@onready var squad_player: PackedScene = preload("res://Scenes/Squad Editor/SquadPlayer/SquadPlayer.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	# First we need to get the formation saved by team
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
""" For Dropping into SquadPlayers """
func drop_data(at_position: Vector2, data):
	# First we need to check if player is attempting to swap
	var swap_player: VBoxContainer = find_swap(at_position, data)
	if swap_player == null:
		# No, so negate this drag attempt
		return
	
	# Yes the player is attempting to swap, so we need to find out where data 
	# is from, whether it is a squad, sub, or reserve
	# First, we can quickly check if it is a squad player
	if data in squad:
		# Yes data is squad player, so we simply swap positions
		var temp_position: Vector2 = data.position
		data.position = swap_player.position
		swap_player.position = temp_position;
		return
	elif data in subs:
		# Yes data is a sub player, so we simply swap positions
		var new_position: Vector2 = swap_player.position
		swap_child_in_grid(sub_area, data, swap_player)
		data.position = new_position;
		
		# Now we have to make data as top level and swap_player as not top level
		data.top_level = true;
		swap_player.top_level = false;
		
		# Now we add data into squad and swap_player to subs
	else:
		# Yes, data is a reserve player
		print("Reserve")
		

	field.add_child(data)
	

	
func find_swap(possible_position: Vector2, data: VBoxContainer) -> VBoxContainer:
	for squad_square: VBoxContainer in squad:
		if squad_square.get_global_rect().has_point(possible_position):
			return squad_square
			
	return null
			
func swap_child_in_grid(grid_container: GridContainer, old_child: Control, new_child: Control):
	# Get the old child at the specified index
	var index: int;
	var children = grid_container.get_children()
	
	for i in range(grid_container.get_child_count()):
		var child = grid_container.get_child(i)
		if child == old_child:
			index = i
			
	if index < 0 or index >= grid_container.get_child_count() or index == null:
		print("Index out of range")
		return
	
	# Remove the old child from the GridContainer
	grid_container.remove_child(old_child)
	
	# Insert the new child at the same index
	# Add the new child temporarily at the end
	grid_container.add_child(new_child)
	
	# Move the new child to the specified index
	grid_container.move_child(new_child, index)
	
	# Ensure the grid updates its layout
	grid_container.queue_sort()


## This function takes prepares the Squad Formation, Subs, and TableList for the whole team
func load_squad_formation():
	# For now we load a default formation
	var player_positions: Array = formations.formations["4-4-2"];
	
	# Now For Each Player Position, we want to put each player into the field rect
	for pos: Vector2 in player_positions:
		# FIrst we need to convert each position to global position in the field rect
		var field_rect: Rect2 = field.get_global_rect();
		
		var global_pos: Vector2 = convert_relative_to_global(pos, field_rect);
		
		# Now we make a squad player instance
		var new_squad_player: VBoxContainer = squad_player.instantiate()
		field_texture.add_child(new_squad_player)
		new_squad_player.top_level = true
		new_squad_player.global_position = global_pos;
		new_squad_player.squad_player_swapped.connect(drop_data)
		
		# Now we push into squad
		squad.push_back(new_squad_player)
		
	# Now we just load the subs
	for i in range(12):
		var new_squad_player: VBoxContainer = squad_player.instantiate()
		sub_area.add_child(new_squad_player)
		new_squad_player.top_level = false
		new_squad_player.squad_player_swapped.connect(drop_data)
		
		# Now we push into subs
		subs.push_back(new_squad_player)

		

## This converts the relative positions to global positions and also accounting for center to top_left conversion
func convert_relative_to_global(relative: Vector2, global_rect: Rect2) -> Vector2:
	var rect_size: Vector2 = global_rect.size;
	# Get ratio with size
	var relative_ratio: Vector2 = Vector2(roundi(float(relative.x) * (float(rect_size.x)/100.0)), roundi(float(relative.y) * (float(rect_size.y)/100.0)));
	var global_center: = global_rect.position + relative_ratio;
	
	# Now convert to center position, we do this by subtract half x and y
	global_center -= 0.5 * Vector2(125, 100)
	
	return global_center
	

func convert_global_to_relative(global_pos: Vector2 , global_rect: Rect2) -> Vector2:
	
	var relative_pos: Vector2 = global_pos - global_rect.position;
	
	# Now we get ratio
	var rect_size: Vector2 = global_rect.size;
	var relative_ratio: Vector2 = Vector2(roundi((relative_pos.x/rect_size.x) * 100.0), roundi((relative_pos.y/rect_size.y) * 100.0))
	
	return relative_ratio; 
	


func _on_button_pressed():
	load_squad_formation()
