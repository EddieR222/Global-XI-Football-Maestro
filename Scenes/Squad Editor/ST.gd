extends Panel

""" Draggable Areas """
@onready var field_texture: TextureRect = get_node("../../../../Field")
@onready var field: HBoxContainer = get_node("../..")
@onready var sub_grid: GridContainer = get_node("../../../../../SubsArea/ScrollContainer/SubArea")


""" Signals """
signal sub_squad_change(new_squad: VBoxContainer, new_sub: VBoxContainer);
signal position_change(player_square: VBoxContainer, new_position: String);

@onready var top_node: TabContainer = get_node("../../../../../../../..")

func _can_drop_data(at_position: Vector2, data) -> bool:
	return true
	
func _drop_data(at_position: Vector2, data):
	# First we need to check if player is attempting to swap with squad player
	var swap_player: VBoxContainer = find_swap(at_position, data)
	
	
	if swap_player:
		# The player has moved the drag preview on top of a player on the field 
		# Yes the player is attempting to swap, so we need to find out where data 
		# is from, whether it is a squad, sub, or reserve
		# INFO: We don't need to validate rules as swapping with an infield player (regardless
		# of if data is another field player, sub, or even reserve) since swapping 
		# a. Doesn't change the number of infield players
		# b. Even if GK is swapped, we still have a new GK so GK remains :)
		
		
		# First, we can quickly check if it is a squad player
		if data in top_node.squad: # INFO: Field player swap with Field player
			# Yes data is squad player, so we simply swap positions
			# Here we are assuming the positions are correct already
			var temp_position: Vector2 = data.position
			data.position = swap_player.position
			swap_player.position = temp_position;
			return
		elif data in top_node.subs:  # INFO: Sub player swap with Field player
			# Yes data is a sub player, so first we add field player into grid container
			# in the same index as the data player was in
			var new_position: Vector2 = swap_player.position
			swap_child_in_grid(sub_grid, data, swap_player)
			
			# Now we have to make data as top level and swap_player as not top level
			data.top_level = true;
			swap_player.top_level = false;
			
			# Finally, place sub into field where swapped player was
			data.position = new_position;
			
			# Now we add data into squad and swap_player to subs
			sub_squad_change.emit(data, swap_player)
		else:
			# Yes, data is a reserve player
			# Not yet implemented
			return
	else:
		# The player has moved the drag preview on top of an empty area on the field
		# Depending on whether the data player is a field player, sub, or reserve
		if data in top_node.squad:
			# Yes, player is attempting to simply move an in field player to another
			# area of the field, no swapping so we simply move the player
			# to the new position
			
			# Since we drag from the middle of the drag preview, we need to calculate
			# the new top corner based on the center position
			var top_left_corner_pos: Vector2 = at_position - (0.5 * data.size) 
			
			# Now we simply move the player to this new position, ensuring the Rect2 of
			# the player remains inside the field texture (done by clamping)
			var field_rect: Rect2 = field.get_global_rect();
			var panel_rect: Rect2 = get_global_rect();
			#data.global_position = top_left_corner_pos.clamp(field_rect.position, field_rect.end) 
			data.global_position = (panel_rect.position + top_left_corner_pos).clamp(field_rect.position, field_rect.end)
			
			position_change.emit(data, "LW")
			return
		else:
			# Since player is attempting to move sub into the field, we must not do anything
			# since doing so would increase the number of infield players to 12. They must swap 
			# in order to get a sub into the field
			
			# Same with reserve player, they must swap with already in field player
			# to get reserve player ontp field
			return

		
	
	

	
func find_swap(possible_position: Vector2, data: VBoxContainer) -> VBoxContainer:
	for squad_square: VBoxContainer in top_node.squad:
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
	
## We call this function to validate that the swap is valid if the player is attempting to swap players[br]
## This function will ensure the following rules[br]
## 1. There is always 11 players on the field, NO MORE NO LESS
## 2. There is always a GK. Players are allowed to swap goalkeeper but there MUST always be a GK position in the formation (even if the player in the GK position is NOT a GK)
## Besides these rules, the players are allowed to move the players any way they see fit. If they want all attack players then thats okay.
func validate_swap():
	pass
