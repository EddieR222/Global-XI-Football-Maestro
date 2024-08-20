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


## This function will run to check if the player has dropped a player square onto another player square.[br]
## Returns null if no player is at the drop point
func find_swap(possible_position: Vector2, data: VBoxContainer) -> VBoxContainer:
	for squad_square: VBoxContainer in top_node.squad:
		if squad_square.get_global_rect().has_point(possible_position):
			return squad_square
			
	for sub_square: VBoxContainer in top_node.subs:
		if sub_square.get_global_rect().has_point(possible_position):
			return sub_square
	return null
			
## This function takes in a GridContainer, and old_child, and a new_child and it swaos the old child for the new child in the 
## grid container. Maintains the indexes of the GridContainer
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
