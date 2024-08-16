extends Panel

""" Draggable Areas """
@onready var field: TextureRect = get_node("../../../../Field")
@onready var sub_grid: GridContainer = get_node("../../../../../SubsArea/ScrollContainer/SubArea")


""" Signals """
signal sub_squad_change(new_squad: VBoxContainer, new_sub: VBoxContainer);

@onready var top_node: TabContainer = get_node("../../../../../../../..")

func _can_drop_data(at_position: Vector2, data) -> bool:
	return true
	
func _drop_data(at_position: Vector2, data):
	# First we need to check if player is attempting to swap
	var swap_player: VBoxContainer = find_swap(at_position, data)
	if swap_player == null:
		# No, so negate this drag attempt
		return
	
	# Yes the player is attempting to swap, so we need to find out where data 
	# is from, whether it is a squad, sub, or reserve
	# First, we can quickly check if it is a squad player
	if data in top_node.squad:
		# Yes data is squad player, so we simply swap positions
		var temp_position: Vector2 = data.position
		data.position = swap_player.position
		swap_player.position = temp_position;
		return
	elif data in top_node.subs:
		# Yes data is a sub player, so we simply swap positions
		var new_position: Vector2 = swap_player.position
		swap_child_in_grid(sub_grid, data, swap_player)
		data.position = new_position;
		
		# Now we delete the old child in the field
		field.remove_child(swap_player)
		
		# Now we have to make data as top level and swap_player as not top level
		data.top_level = true;
		swap_player.top_level = false;
		
		# Now we add data into squad and swap_player to subs
		sub_squad_change.emit(data, swap_player)
	else:
		# Yes, data is a reserve player
		print("Reserve")
		

	field.add_child(data)
	

	
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
