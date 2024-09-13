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
