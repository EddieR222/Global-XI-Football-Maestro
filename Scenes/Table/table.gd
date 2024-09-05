extends ScrollContainer

""" Sections """
@onready var title_row: ItemList = %Title;
@onready var data_item_list: ItemList = %Data;
@onready var Entire_Table: VBoxContainer = %Control

""" Data """
@export var dataframe: Dataframe;
@export var _copy_dataframe: Array[Dictionary] = []
@export var rows: int;
@export var cols: int;


@export var max_length: Dictionary;
@export var icon_columns: Dictionary;
const ABSOLUTE_MAX_STRING_LENGTH: int = 50;

""" Text Icons """
const down_arrow: String = "▼"
const up_arrow: String = "▲" 
const neutral: String = "-"
const star_emoji: String = "⭐"

""" Font and Icon Info """
const FONT_SIZE: int = 16
const FONT_PIXEL_WIDTH: int = roundi(FONT_SIZE * 0.75)
@onready var ICON_WIDTH_IN_LETTER: int = data_item_list.fixed_icon_size.x / FONT_PIXEL_WIDTH;

""" Position Colors """
const GOALKEPPER_FONT_COLOR: Color = Color(206.0/255.0, 131.0/255.0, 1.0);
const DEFENDER_FONT_COLOR: Color = Color(50.0/255.0, 1.0, 50.0/255.0);
const MIDFIELDER_FONT_COLOR: Color = Color(50.0/255.0, 153.0/255.0, 1.0);
const ATTACKER_FONT_COLOR: Color = Color(1.0, 0.0/255.0, 0.0/255.0);


""" Adding Data to Table """
## This function is used to initialize the table with data
func set_data(data: Dataframe) -> void:
	dataframe = data;

	
	cols = dataframe.title_names.size()
	rows = dataframe.data.size();
	data_item_list.max_columns = cols;
	
	# Calculate Max Text Lengths
	max_length = calculate_max_text_lengths(dataframe);
	
	add_title_row()

	for row: int in range(rows):
		add_row(row)
		
	var minimum_size_x: int = calculate_minimum_horizontal_size();
	Entire_Table.custom_minimum_size.x = minimum_size_x
		


## This function will add the title rows of the dataframe. WARNING: Must be called after set_data or after dataframe variable is set
func add_title_row() -> bool:
	# First we clear if anything previously had
	title_row.clear()
	
	for column: String in dataframe.title_names:
		title_row.add_item(prepare_text(column, column, false), null, true);
	
	return true

## This functions will add a single row of data to the table. WARNING: Must be called after calling the "calculate_max_length" function as we need the _copy_dataframe set
func add_row(data_index: int) -> void:
	var row_text_and_icons: Dictionary = _copy_dataframe[data_index]
	for column: String in dataframe.title_names:
		# Get Text if any, otherwise put N/A
		var cell_text: String = row_text_and_icons[column] if column in row_text_and_icons.keys() else "N/A"
		
		# Get Icon for item if any
		var image: Image = row_text_and_icons[column + "_icon"] if (column + "_icon") in row_text_and_icons.keys() else null
		var cell_icon: ImageTexture = null;
		if image != null:
			cell_icon = ImageTexture.create_from_image(image)
			cell_text = prepare_text(cell_text, column, true)
		else:
			cell_text = prepare_text(cell_text, column, false)
			
		# Now we add item to list
		var index: int = data_item_list.add_item(cell_text, cell_icon, false);

		# INFO SPECIAL CASES: Position or Overall/Potential
		handle_special_cases(index, cell_text, column);


""" Data Preperation """
## This function takes in a recently added item to the data table and handles any special cases such as adding color to text and other special cases.[br]
## This depends on the column name so adding any case here must be unique as other columns with the same name will exhibit any effects added here.
func handle_special_cases(index: int, cell_text: String, column: String) -> bool:
	# First thing first, we ensure the cell_text is "unprepared" so we get the original text
	cell_text = cell_text.strip_edges()
	
	# Second, we see which special case to handle
	
	match column:
		"Position": # Position Column so we apply color coded positions 
			if PlayerManager.convert_to_int_position(cell_text.strip_edges()) != -1:
					# Valid Position String so we color code it
					var pos: int = PlayerManager.convert_to_int_position(cell_text.strip_edges());
					if pos == 0:
						data_item_list.set_item_custom_fg_color(index, GOALKEPPER_FONT_COLOR)
					elif pos <= 6: 
						data_item_list.set_item_custom_fg_color(index, DEFENDER_FONT_COLOR)
					elif pos <= 11:
						data_item_list.set_item_custom_fg_color(index, MIDFIELDER_FONT_COLOR)
					else:
						data_item_list.set_item_custom_fg_color(index, ATTACKER_FONT_COLOR)
		"Overall": # Rating Column so we apply linear interpolation of the rating (Red -> Green)
			var rating: int = cell_text.strip_edges().to_int();
			var rating_color: Color = determine_rating_color(float(rating))
			data_item_list.set_item_custom_fg_color(index, rating_color)
		"Potential": # Rating Column so we apply linear interpolation of the rating (Red -> Green)
			var rating: int = cell_text.strip_edges().to_int();
			var rating_color: Color = determine_rating_color(float(rating))
			data_item_list.set_item_custom_fg_color(index, rating_color)
		"Condition":
			if cell_text == "Healthy":
				data_item_list.set_item_custom_fg_color(index, ATTACKER_FONT_COLOR) # reuse color since it is a nice shade and visible
			elif cell_text == "Injury Prone":
				data_item_list.set_item_custom_fg_color(index, Color(1.0, 1.0, 0.0))
			else:
				data_item_list.set_item_custom_fg_color(index, DEFENDER_FONT_COLOR)
		"Skill Moves":
			var total_length: int = max_length[column]
			var padding_needed = total_length - cell_text.length() - 4
			cell_text = "    " + cell_text + " ".repeat(padding_needed)
			data_item_list.set_item_text(index, cell_text)
			data_item_list.set_item_custom_fg_color(index, Color(1.0, 1.0, 0.0))
		"Weak Foot":
			var total_length: int = max_length[column]
			var padding_needed = total_length - cell_text.length() - 4
			cell_text = "    " + cell_text + " ".repeat(padding_needed)
			data_item_list.set_item_text(index, cell_text)
			data_item_list.set_item_custom_fg_color(index, Color(1.0, 1.0, 0.0))
		"Morale":
			if cell_text == "Very UnHappy":
				data_item_list.set_item_custom_fg_color(index, ATTACKER_FONT_COLOR)
			elif cell_text == "UnHappy":
				data_item_list.set_item_custom_fg_color(index, Color(1.0, 153.0/255.0, 51.0/255.0))
			elif cell_text == "Neutral":
				data_item_list.set_item_custom_fg_color(index, Color(1.0, 1.0, 0.0))
			elif cell_text == "Happy":
				data_item_list.set_item_custom_fg_color(index, Color(153.0/255.0, 1.0, 51.0/255.0))
			else:
				data_item_list.set_item_custom_fg_color(index, DEFENDER_FONT_COLOR)
		"Sharpness":
			if cell_text == "Very UnFit":
				data_item_list.set_item_custom_fg_color(index, ATTACKER_FONT_COLOR)
			elif cell_text == "UnFit":
				data_item_list.set_item_custom_fg_color(index, Color(1.0, 153.0/255.0, 51.0/255.0))
			elif cell_text == "Neutral":
				data_item_list.set_item_custom_fg_color(index, Color(1.0, 1.0, 0.0))
			elif cell_text == "Fit":
				data_item_list.set_item_custom_fg_color(index, Color(153.0/255.0, 1.0, 51.0/255.0))
			else:
				data_item_list.set_item_custom_fg_color(index, DEFENDER_FONT_COLOR)
	
	
	
	return true

## This prepares any text that will be going on the table. This essentially works to add padding for both titles and column data and also ensures all data is correctly aligned
func prepare_text(text: String, column: String, icon: bool) -> String:
	var total_length: int = min(max_length[column], ABSOLUTE_MAX_STRING_LENGTH if !icon  else ABSOLUTE_MAX_STRING_LENGTH - ICON_WIDTH_IN_LETTER)
	if text == column and !icon_columns[column]:
		text = text + neutral
	elif text == column and icon_columns[column]:
		text = text + neutral
		total_length += ICON_WIDTH_IN_LETTER + 1
		
	var padding_needed = total_length - text.length();
	

	if padding_needed > 0: 
		var left_padding = padding_needed / 2 #if !icon else 0
		var right_padding = padding_needed - left_padding
		return " ".repeat(left_padding) + text + " ".repeat(right_padding)
	elif padding_needed < 0:
		return text.left(total_length - 3) + "..."
	else:
		return text

## This function does quite a lot but it does calculate the max lengths for every column, saves whether each column holds an icon or not, and assembles the much needed _copy_dataframe variable
func calculate_max_text_lengths(data: Dataframe) -> Dictionary:
	# Clear previous things
	icon_columns.clear()
	_copy_dataframe.clear()
	
	# Start Return Dictionary
	var dict: Dictionary;
	
	# Initialize values as minimum of length of column name (plus 1)
	for column: String in dataframe.title_names:
		dict[column] = column.length() + 1; # Add 1 to account for up and down arrow that all columns will have
	
	# Now go through each data and find max length of column, whether it holds an icon, and build easy to work with database
	for row_data in data.data:
		var row_text_and_icons: Dictionary = dataframe.get_text_and_icon.call(row_data);
		for column: String in dataframe.title_names:
			# Calculate Max Length
			var cell_text: String = row_text_and_icons[column] if column in row_text_and_icons.keys() else "N/A"
			dict[column] = max(dict[column], cell_text.length())
			
			# Determine Icon in Column
			if column + "_icon" in row_text_and_icons.keys():
				icon_columns[column] = true;
			else:
				icon_columns[column] = false;
	
			# Bui;d Easy to Work with Database
		_copy_dataframe.push_back(row_text_and_icons)
			
	
	return dict

## This function determines the Color needed for the passed in rating number. This does a linear interpolation of the rating value going from red -> yellow -> green for values between 0 -> 100.
func determine_rating_color(value: float) -> Color:
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

func calculate_minimum_horizontal_size() -> int:
	var total_width: int = 200; #extra 25 pixels for good measure
	# Add size of item column to length
	for column: String in dataframe.title_names:
		total_width += (min(max_length[column], ABSOLUTE_MAX_STRING_LENGTH) * FONT_PIXEL_WIDTH)
		
	# Now we add spacing
	var horizontal_seperation: int = data_item_list.get_theme_constant("h_seperation");
	total_width += (horizontal_seperation * dataframe.title_names.size())
	

	return total_width


""" Signal Handlers """
## When the user clicks the column's title item, here we either sort (ascending or descending) or go back to neutral
func _on_title_item_selected(index: int) -> void:
	# First we can determine column selected by the index
	var column_selected: String = dataframe.title_names[index]
	
	# Now we can use the current column name to determine what state it was selected previously
	var curr_column: String = title_row.get_item_text(index)
	if curr_column.contains(up_arrow):
		# This means it was previously sorted upwards, so now we sort downwards
		_copy_dataframe.sort_custom(
			func(a: Dictionary, b: Dictionary): 
				var a_column_string: String =  a[column_selected];
				if a_column_string.is_valid_int():
					return a_column_string.to_int() <= b[column_selected].to_int()
				elif a_column_string.is_valid_float():
					return a_column_string.to_float() <= b[column_selected].to_float();
				elif PlayerManager.convert_to_int_position(a_column_string) != -1:
					return PlayerManager.convert_to_int_position(a_column_string) <= PlayerManager.convert_to_int_position(b[column_selected])
				else:
					return UnicodeNormalizer.normalize(a[column_selected].to_lower()) >= UnicodeNormalizer.normalize(b[column_selected].to_lower()));
		add_title_row()
		data_item_list.clear()
		for row: int in range(rows):
			add_row(row)
			
		# Set text to indicate it is now descending
		title_row.set_item_text(index, curr_column.replace(up_arrow, down_arrow))
			
	elif curr_column.contains(down_arrow):
		# This means it was previously sorted downwards, we now return to neutral (by default, players will be sorted ascending by first row)
		_copy_dataframe.sort_custom(
			func(a: Dictionary, b: Dictionary): 
				var a_column_string: String =  a[dataframe.title_names[0]];
				if a_column_string.is_valid_int():
					return a_column_string.to_int() <= b[dataframe.title_names[0]].to_int()
				elif a_column_string.is_valid_float():
					return a_column_string.to_float() <= b[dataframe.title_names[0]].to_float();
				elif PlayerManager.convert_to_int_position(a_column_string) != -1:
					return PlayerManager.convert_to_int_position(a_column_string) <= PlayerManager.convert_to_int_position(b[dataframe.title_names[0]])
				else:
					return UnicodeNormalizer.normalize(a[column_selected].to_lower()) >= UnicodeNormalizer.normalize(b[dataframe.title_names[0]].to_lower()));
		add_title_row()
		data_item_list.clear()
		for row: int in range(rows):
			add_row(row)
			
		# Set text to indicate it is now descending
		title_row.set_item_text(0, title_row.get_item_text(0).replace(neutral, up_arrow))
		
	elif curr_column.contains(neutral):
		# This means it was previously sorted upwards, so now we sort downwards
		_copy_dataframe.sort_custom(
			func(a: Dictionary, b: Dictionary): 
				var a_column_string: String =  a[column_selected];
				if a_column_string.is_valid_int():
					return a_column_string.to_int() >= b[column_selected].to_int()
				elif a_column_string.is_valid_float():
					return a_column_string.to_float() >= b[column_selected].to_float();
				elif PlayerManager.convert_to_int_position(a_column_string) != -1:
					return PlayerManager.convert_to_int_position(a_column_string) >= PlayerManager.convert_to_int_position(b[column_selected])
				else:
					return UnicodeNormalizer.normalize(a[column_selected].to_lower()) <= UnicodeNormalizer.normalize(b[column_selected].to_lower()));
		add_title_row()
		data_item_list.clear()
		for row: int in range(rows):
			add_row(row)
			
		# Set text to indicate it is now descending
		title_row.set_item_text(index, curr_column.replace(neutral, up_arrow))
	

