extends ScrollContainer

""" Sections """
@onready var title_row: ItemList = %Title;
@onready var data_item_list: ItemList = %Data;

""" Scenes """
@onready var header_button: PackedScene = preload("res://Scenes/Table/tableheader.tscn")

""" Data """
@export var dataframe: Dataframe;

@export var rows: int;
@export var cols: int;


@export var max_length: Dictionary



func set_data(data: Dataframe) -> void:
	dataframe = data;
	
	cols = dataframe.title_names.size()
	rows = dataframe.data.size();
	data_item_list.max_columns = cols;
	
	# Calculate Max Text Lengths
	max_length = calculate_max_text_lengths(dataframe);
	
	add_title_row()

	for row: int in range(rows):
		add_row(dataframe.data[row])
		
	
	
	
func add_title_row() -> bool:
	#var index: int = 0;
	#for column: String in dataframe.title_names:
		## Pad Column Name
		#var column_string: String = prepare_text(column, column, true)
		#
		## Now instantiate
		#var header: Button = header_button.instantiate()
		#header.text = column_string
		#
		## Now adjust size
		#if data_item_list.get_item_icon(index) != null:
			#header.text = "--" + column_string + "--"
		#
		## Now add child
		#title_row.add_child(header);
		#
		#index += 1
		
	for column: String in dataframe.title_names:
		title_row.add_item(column, null, true);
		
		
	return true


func add_row(row_data) -> void:
	var row_text_and_icons: Dictionary = dataframe.get_text_and_icon.call(row_data);
	for column: String in dataframe.title_names:
		# Get Text if any, otherwise put N/A
		var cell_text: String = row_text_and_icons[column] if column in row_text_and_icons.keys() else "N/A"
		
		# Get Icon for item if any
		var image: Image = row_text_and_icons[column + "_icon"] if (column + "_icon") in row_text_and_icons.keys() else null
		var cell_icon: ImageTexture = null;
		if image != null:
			cell_icon = ImageTexture.create_from_image(image)
			cell_text = prepare_text(cell_text, column, false)
		else:
			cell_text = prepare_text(cell_text, column, true)
			
		
		# Now we add item to list
		var index: int = data_item_list.add_item(cell_text, cell_icon, false);
		
		# Now we check if current column is metadata column
		if column == dataframe.metadata_column:
			data_item_list.set_item_metadata(index, row_data);
		

func fix_column_widths() -> void:
	var rect: Rect2 = data_item_list.get_item_rect(1, true)
	rect.grow_side(2, 1000)
	
func prepare_text(text: String, column: String, icon: bool) -> String:
	var total_length: int = max_length[column]
	var padding_needed = total_length - text.length()
	

	if padding_needed > 0: 
		var left_padding = padding_needed / 2 if icon else 0
		var right_padding = padding_needed - left_padding
		return " ".repeat(left_padding) + text + " ".repeat(right_padding)
	elif padding_needed < 0:
		return text.left(total_length - 3) + "..."
	else:
		return text



func calculate_max_text_lengths(data: Dataframe) -> Dictionary:
	# Start Return Dictionary
	var dict: Dictionary;
	for column: String in dataframe.title_names:
		dict[column] = column.length();
	
	for row_data in data.data:
		var row_text_and_icons: Dictionary = dataframe.get_text_and_icon.call(row_data);
		for column: String in dataframe.title_names:
			var cell_text: String = row_text_and_icons[column] if column in row_text_and_icons.keys() else "N/A"
			dict[column] = max(dict[column], cell_text.length())
	
	return dict
			
	
	
