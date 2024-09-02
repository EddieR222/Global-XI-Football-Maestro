extends ScrollContainer

""" Sections """
@onready var title_row: HBoxContainer = %Title;
@onready var data_item_list: ItemList = %Data;



""" Data """
@export var dataframe: Dataframe;

@export var rows: int;
@export var cols: int;




func set_data(data: Dataframe) -> void:
	dataframe = data;
	
	cols = dataframe.title_names.size()
	rows = dataframe.data.size();
	data_item_list.max_columns = cols;
	
	for row: int in range(rows):
		add_row(dataframe.data[row])
		
	
	
func add_title_row(titles: Array[String]) -> bool:
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
			
		
		# Now we add item to list
		var index: int = data_item_list.add_item(cell_text, cell_icon, false);
		
		# Now we check if current column is metadata column
		if column == dataframe.metadata_column:
			data_item_list.set_item_metadata(index, row_data);
		

func fix_column_widths() -> void:
	var rect: Rect2 = data_item_list.get_item_rect(1, true)
	rect.grow_side(2, 1000)
