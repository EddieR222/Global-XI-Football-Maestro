extends VBoxContainer

# Table Row Scene
@onready var table_row: PackedScene = preload("res://Scenes/Table/table_row.tscn");

# Table Cells
@onready var header_cell: PackedScene = preload("res://Scenes/Table/table_header_cell.tscn");
@onready var table_cell_icon: PackedScene = preload("res://Scenes/Table/table_cell_icon_and_text.tscn");
@onready var table_cell_text: PackedScene = preload("res://Scenes/Table/table_cell_text.tscn");

# Row Items
var row_items: Array[Player] = [];


# Team to Display Players of
var team: Team;

func _ready():
	add_column_header_row(["position", "name", "age", "Nationality"])
	


func add_column_header_row(columns: Array[String]) -> void:
	# First we need to add a table row to the table
	var header_row: HBoxContainer = table_row.instantiate();
	add_child(header_row)
	
	# Now we add a header cell to the header row for each column string
	for col: String in columns:
		var header: Button = header_cell.instantiate();
		header.display_data(col);
		header.pressed.connect(_on_column_button_clicked)
		header_row.add_child(header)
		

func add_player_row(player: Player) -> void:
	# First, we instantiate a new row and add to table
	var row: HBoxContainer = table_row.instantiate()
	add_child(row);
	
	# We will be adding cells by column order
	# First is the player position
	var cell: Label = table_cell_text.instantiate();
	cell.display_data(player.get_player_positions()[0])
	row.add_child(cell)
	
	# Second, we add player name and player face
	var cell_icon: Button = table_cell_icon.instantiate()
	cell.display_data(player.get_player_name(), player.get_player_face())
	row.add_child(cell_icon)
	
	# Third, we add shirt number
	#cell = table_cell_text.instantiate();
	#cell.display_data(player.get_player_shirt_number());
	#row.add_child(cell);
	
	# Fourth, we add player nationality
	#cell_icon = table_cell_icon.instantiate()


func _on_column_button_clicked(column: String) -> void:
	# First we have to see if column selected is currently ascending or descending
	print(column)
