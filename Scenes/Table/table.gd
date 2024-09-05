extends ScrollContainer

""" Sections """
@onready var title_row: ItemList = %Title;
@onready var data_item_list: ItemList = %Data;

""" Data """
@export var dataframe: Dataframe;
@export var _copy_dataframe: Array[Dictionary] = []
@export var rows: int;
@export var cols: int;


@export var max_length: Dictionary;
@export var icon_columns: Dictionary;
const ABSOLUTE_MAX_STRING_LENGTH: int = 50;

""" Icons """
const down_arrow: String = "▼"
const up_arrow: String = "▲" 
const neutral: String = "-"

""" Font and Icon Info """
const FONT_PIXEL_WIDTH: int = 10;
@onready var ICON_WIDTH_IN_LETTER: int = data_item_list.fixed_icon_size.x / FONT_PIXEL_WIDTH;

# Position Colors
const GOALKEPPER_FONT_COLOR: Color = Color(206.0/255.0, 131.0/255.0, 1.0);
const DEFENDER_FONT_COLOR: Color = Color(50.0/255.0, 1.0, 50.0/255.0);
const MIDFIELDER_FONT_COLOR: Color = Color(50.0/255.0, 153.0/255.0, 1.0);
const ATTACKER_FONT_COLOR: Color = Color(1.0, 0.0/255.0, 0.0/255.0);

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



func add_title_row() -> bool:
	# First we clear if anything previously had
	title_row.clear()
	
	for column: String in dataframe.title_names:
		title_row.add_item(prepare_text(column, column, false), null, true);
	
	return true


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
		if PlayerManager.convert_to_int_position(cell_text.strip_edges()) != -1 and column == "Position":
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
		if column == "Overall" or column == "Potential":
			var rating: int = cell_text.strip_edges().to_int();
			var rating_color: Color = determine_rating_color(float(rating))
			data_item_list.set_item_custom_fg_color(index, rating_color)
			


func prepare_text(text: String, column: String, icon: bool) -> String:
	var total_length: int = min(max_length[column], ABSOLUTE_MAX_STRING_LENGTH if !icon  else ABSOLUTE_MAX_STRING_LENGTH - ICON_WIDTH_IN_LETTER)
	if text == column and !icon_columns[column]:
		text = text + neutral
	elif text == column and icon_columns[column]:
		text = text + neutral
		total_length += ICON_WIDTH_IN_LETTER
		
	var padding_needed = total_length - text.length();
	

	if padding_needed > 0: 
		var left_padding = padding_needed / 2 #if !icon else 0
		var right_padding = padding_needed - left_padding
		return " ".repeat(left_padding) + text + " ".repeat(right_padding)
	elif padding_needed < 0:
		return text.left(total_length - 3) + "..."
	else:
		return text



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
		
		

