extends VBoxContainer

""" Player Information """
var player: Player;
var relative_position: Vector2;

""" Constants """
# Position Colors
const GOALKEPPER_FONT_COLOR: Color = Color(206.0/255.0, 131.0/255.0, 1.0);
const DEFENDER_FONT_COLOR: Color = Color(50.0/255.0, 1.0, 50.0/255.0);
const MIDFIELDER_FONT_COLOR: Color = Color(50.0/255.0, 153.0/255.0, 1.0);
const ATTACKER_FONT_COLOR: Color = Color(1.0, 0.0/255.0, 0.0/255.0);




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
	
	set_player_name(player.Name)
	
	# Display Rating
	set_player_rating(player.Overall)
	
	# Display Position
	set_player_position(player.Positions[0]);
	
	# Display Player Face
	set_player_face(player.get_player_face())
	
	# Set Player Stamina
	set_stamina(player.Stamina_Level)
	
	
	return true
	
func set_player_name(full_name: String) -> bool:
	# Display Player Name
	var player_name: Label = %PlayerName
	
	# Get Player Name
	var player_name_split: Array = full_name.strip_edges().split(" ")
	var first_name: String = player_name_split.pop_front();
	var last_name: String = player_name_split.pop_back();
	var first_name_letter: String = first_name.left(1);
	
	# Display it
	player_name.text = first_name_letter + ". " + last_name
	
	return true

func set_player_position(pos: int) -> bool:
	var position_label: Label = %Position
	position_label.text = PlayerManager.convert_to_string_position(pos);
	if pos == 0:
		position_label.add_theme_color_override("font_color", GOALKEPPER_FONT_COLOR)
	elif pos <= 6: 
		position_label.add_theme_color_override("font_color", DEFENDER_FONT_COLOR)
	elif pos <= 11:
		position_label.add_theme_color_override("font_color", MIDFIELDER_FONT_COLOR)
	else:
		position_label.add_theme_color_override("font_color", ATTACKER_FONT_COLOR)
	
	# Remake Tooltip 
	generate_tooltip()
	
	
	return true

func set_player_rating(rating: int) -> bool:
	# Display Rating
	var rating_label: Label = %Rating;
	rating_label.text = str(rating);
	
	# Remake Tooltip 
	generate_tooltip()
	
	return true

func set_player_face(face: Image) -> bool:
	var player_face: Image = face
	if player_face == null:
		return false
	var player_face_diplay: TextureRect = %PlayerFace
	var texture_image: ImageTexture = ImageTexture.create_from_image(player_face)
	player_face_diplay.texture = texture_image
	return true

func set_stamina(stamina_level: int) -> void:
	# First we need to get the stamina level color
	var stamina_color: Color = determine_stamina_color(float(stamina_level))
	
	# Now we display it 
	var stamina_bar: ProgressBar = %Stamina
	stamina_bar.value = float(stamina_level)
	var style_box: StyleBox = StyleBoxFlat.new()
	stamina_bar.add_theme_stylebox_override("fill", style_box)
	style_box.bg_color = stamina_color
	
	# Remake Tooltip 
	generate_tooltip()


func determine_stamina_color(value: float) -> Color:
	# Ensure value is clamped between 0 and 100
	value = clamp(value, 0.0, 100.0)

	# Define color ranges: red (0) -> yellow (50) -> green (100)
	var red = Color(1.0, 0.0, 0.0)   # Dark Red
	var yellow = Color(1.0, 1.0, 0.0) # Yellow
	var green = Color(0.0, 1.0, 0.0)  # Dark Green

	if value < 50.0:
		# Interpolate between red and yellow
		return red.lerp(yellow, value / 50.0)
	else:
		# Interpolate between yellow and green
		return yellow.lerp(green, (value - 50.0) / 50.0)

func generate_tooltip() -> void:
	# First we get all the text we need
	var player_name: String = player.Name
	var player_position: String = %Position.text;
	var player_rating: String = %Rating.text
	var player_age: String = str(player.Age)
	var player_height: String = str(player.Height) + " cm"
	var player_weight: String = str(player.Weight) + " kg"
	var player_stamina: String = str(%Stamina.value)
	
	# Now we format string
	var tooltip_message: String = "%s\nPosition: %s\nRating: %s\nAge: %s\nHeight: %s\nWeight: %s\nStamina Level: %s" % [player_name, player_position, player_rating, player_age, player_height, player_weight, player_stamina]
	
	# Set Tooltip
	tooltip_text = tooltip_message
	
	return

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
	
