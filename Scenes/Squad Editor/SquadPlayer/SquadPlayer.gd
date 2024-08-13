extends CharacterBody2D
## This is the node structure that forms the Player Details Display for when building a squad


## The player being displayed
var player: Player;

var can_grab: bool = false;
var grabbed_offset: Vector2 = Vector2();

func _input(event):
	if event is InputEventMouseButton:
		can_grab = event.pressed;
		grabbed_offset = position - get_global_mouse_position();
		
func _process(delta: float):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_grab:
		position = get_global_mouse_position() + grabbed_offset;



func set_player(input_player: Player) -> bool:
	# Validate that Player has name
	if input_player.Name.is_empty():
		return false;
		
	# Now we just set player
	player = input_player;	
	
	return true
	
	
func display_player_info() -> void:
	# First thing first, we need to display the face of the player
	pass
