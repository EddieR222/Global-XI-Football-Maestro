extends TabContainer

var team: Team;
var squad: Array[VBoxContainer];
var subs: Array[VBoxContainer];

@onready var field_texture: TextureRect = get_node("Formation/TeamFormationDetails/TeamFormation/FieldandSquad/Field");
@onready var field: HBoxContainer = get_node("Formation/TeamFormationDetails/TeamFormation/FieldandSquad/MarginContainer/FieldBox");
@onready var sub_area: GridContainer = get_node("Formation/TeamFormationDetails/TeamFormation/SubsArea/ScrollContainer/SubArea")

""" Panels """
@onready var field_panels: Array[Panel] = [%LW, %LM, %LWB, %LB, %ST, %CF, %SS, %CAM, %CM, %CDM, %CB, %SW, %GK, %RW, %RM, %RWB, %RB ]
@onready var formations: DefaultFormations = DefaultFormations.new()
@onready var squad_player: PackedScene = preload("res://Scenes/Squad Editor/SquadPlayer/SquadPlayer.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	# First we need to get the formation saved by team
	call_deferred("load_squad_formation", Team.new())

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
""" For Dropping into SquadPlayers """
## This function will be called whenever a player is dropped onto the empty soccer field.
func drop_data(at_position: Vector2, data):
	# We need to see which player is attempting to be swapped
	var swap_player: VBoxContainer = find_swap(at_position, data)
	
	
	# Now we check if the swap_player is in the squad
	if swap_player in squad:
		# The player has moved the drag preview on top of a player on the field 
		# Yes the player is attempting to swap, so we need to find out where data 
		# is from, whether it is a squad, sub, or reserve
		# INFO: We don't need to validate rules as swapping with an infield player (regardless
		# of if data is another field player, sub, or even reserve) since swapping 
		# a. Doesn't change the number of infield players
		# b. Even if GK is swapped, we still have a new GK so GK remains :)
		
		# First, we can quickly check if it is a squad player
		if data in squad: # INFO: Field player swap with Field player
			if data.name == swap_player.name: # If the player is on own player, just move the player
				# Yes, player is attempting to simply move an in field player to another
				# area of the field, no swapping so we simply move the player
				# to the new position
				
				# Since we drag from the middle of the drag preview, we need to calculate
				# the new top corner based on the center position
				var top_left_corner_pos: Vector2 = at_position - (0.5 * data.size) 
				
				# Now we simply move the player to this new position, ensuring the Rect2 of
				# the player remains inside the field texture (done by clamping)
				var field_rect: Rect2 = field.get_global_rect();
				data.global_position = top_left_corner_pos.clamp(field_rect.position, field_rect.end)
				
				# Now we need to find which panel has this new position
				for positions: Panel in field_panels:
					if positions.get_global_rect().has_point(data.global_position):
						# Now we have found the position panel, we can assign a new position
						print("Position Changed")
				return
				
				
			else:	
				# Yes data is squad player, so we simply swap positions
				# Here we are assuming the positions are correct already
				var temp_position: Vector2 = data.position
				data.position = swap_player.position
				swap_player.position = temp_position;
				return
		elif data in subs:  # INFO: Sub player swap with Field player
			# Yes data is a sub player, so first we add field player into grid container
			# in the same index as the data player was in
			var new_position: Vector2 = swap_player.global_position
			swap_child_in_grid(sub_area, data, swap_player)
			
			# Now we have to make data as top level and swap_player as not top level
			data.top_level = true;
			swap_player.top_level = false;
			
			# Finally, place sub into field where swapped player was
			data.global_position = new_position;
			#swap_player.position = Vector2(0,0)
			
			# Now we add data into squad and swap_player to subs
			squad.push_back(data)
			squad.erase(swap_player)
			
			subs.push_back(swap_player)
			subs.erase(data)
		else:
			# Yes, data is a reserve player
			# Not yet implemented
			return
	elif swap_player in subs:
		if data in squad:
			var new_position: Vector2 = data.global_position
			swap_child_in_grid(sub_area, swap_player, data)
			
			# Now we have to make data as top level and swap_player as not top level
			swap_player.top_level = true;
			data.top_level = false;
			
			# Finally, place sub into field where swapped player was
			swap_player.global_position = new_position;
			
			# Now we add data into squad and swap_player to subs
			squad.push_back(swap_player)
			squad.erase(data)
			
			subs.push_back(data)
			subs.erase(swap_player)
		elif data in subs:
			# Here we are simply switching spots of subs
			swap_places_in_grid(sub_area, data, swap_player)
			print("Done")
			
		else:
			print("reserve")


## This function will run to check if the player has dropped a player square onto another player square.[br]
## Returns null if no player is at the drop point
func find_swap(possible_position: Vector2, data: VBoxContainer) -> VBoxContainer:
	for squad_square: VBoxContainer in squad:
		if squad_square.get_global_rect().has_point(possible_position):
			return squad_square
			
	for sub_square: VBoxContainer in subs:
		if sub_square.get_global_rect().has_point(possible_position):
			return sub_square
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
	
	# Remove the old child from the GridContainer and reparent with field
	grid_container.remove_child(old_child)
	field_texture.add_child(old_child)
	
	
	
	# Insert the new child at the same index
	# Add the new child temporarily at the end
	field_texture.remove_child(new_child)
	grid_container.add_child(new_child)
	
	# Move the new child to the specified index
	grid_container.move_child(new_child, index)
	
	# Ensure the grid updates its layout
	grid_container.queue_sort()

func swap_places_in_grid(grid_container: GridContainer, child_1: Control, child_2: Control):
	# Get the old child at the specified index
	var child_1_index: int;
	var child_2_index: int;
	var children = grid_container.get_children()
	
	for i in range(grid_container.get_child_count()):
		var child = grid_container.get_child(i)
		if child == child_1:
			child_1_index = i
		if child == child_2:
			child_2_index = i
			
	# Move the new child to the specified index
	grid_container.move_child(child_1, child_1_index)
	grid_container.move_child(child_2, child_2_index)


## This function takes prepares the Squad Formation, Subs, and TableList for the whole team
func load_squad_formation(_team: Team) -> bool:
	team = _team;
	
	# For now we load a default formation
	var player_positions: Array = formations.formations["4-4-2"];
	
	# Generate Players for Squad
	#var squad_players: Array[Player] = GameMapManager.game_map.player_manager.generate_team_squad(0, 100, 0)
	
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
		new_squad_player.relative_position = pos
		#new_squad_player.player = squad_player.pop_back()
		
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
	
	return true

## This function simply takes the existing 
func redraw_squad() -> bool:
	for player: VBoxContainer in squad:
		var field_position: Vector2 = player.relative_position;
		var field_rect: Rect2 = field.get_global_rect();
		var field_global_position: Vector2 = convert_relative_to_global(field_position, field_rect);
		player.global_position = field_global_position
		
		
	return true
		

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
	



""" """

#
func _on_visibility_changed() -> void:
	redraw_squad()

