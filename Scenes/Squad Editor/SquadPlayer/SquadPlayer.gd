extends VBoxContainer

var player: Player;

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
	# Otherwise, just check data
	return true
	
func _drop_data(at_position: Vector2, data):
	squad_player_swapped.emit(at_position, data);


	

