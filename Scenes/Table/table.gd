extends ScrollContainer

# Table Row Scene
@onready var table_row: PackedScene = preload("res://Scenes/Table/table_row.tscn");

# Table Cells
@onready var header_cell: PackedScene = preload("res://Scenes/Table/table_header_cell.tscn");
@onready var table_cell_icon: PackedScene = preload("res://Scenes/Table/table_cell_icon_and_text.tscn");
@onready var table_cell_text: PackedScene = preload("res://Scenes/Table/table_cell_text.tscn");

# Sections
@onready var title_row: MarginContainer = get_node("Control/Title");
@onready var rows: VBoxContainer = get_node("Control/RowScroll/Rows")


# Row Items
var row_items: Array[Player] = [];


# Team to Display Players of
var team: Team;

func _ready():
	add_column_header_row(["Position", "Name", "Age", "Nationality", "No.", "Overall", "Potential", "Condition", "Morale", "Sharpness"]);
	


func add_column_header_row(columns: Array[String]) -> void:
	# First we need to add a table row to the table
	var header_row: HBoxContainer = table_row.instantiate();
	title_row.add_child(header_row)
	
	# Now we add a header cell to the header row for each column string
	for col: String in columns:
		var header: Button = header_cell.instantiate();
		header.display_data(col);
		header.pressed.connect(_on_column_button_clicked)
		if col == "Name" or col == "Nationality":
			header.size_flags_stretch_ratio = 4;
		header_row.add_child(header)
		
func set_player_list(players_list: Array[Player]) -> bool:
	row_items = players_list;
	
	for player: Player in players_list:
		add_player_row(player)
	
	return true

func add_player_row(player: Player) -> void:
	# First, we instantiate a new row and add to table
	var row: HBoxContainer = table_row.instantiate()
	rows.add_child(row);
	
	# We will be adding cells by column order
	# First is the player position
	var cell: Label = table_cell_text.instantiate();
	cell.display_data(PlayerManager.convert_to_string_position(player.Positions[0]))
	row.add_child(cell)
	
	# Second, we add player name and player face
	var cell_icon: Button = table_cell_icon.instantiate()
	cell_icon.display_data(player.Name, player.get_player_face())
	row.add_child(cell_icon)
	
	# Third, we Age
	cell = table_cell_text.instantiate();
	cell.display_data(str(player.Age));
	row.add_child(cell);
	
	# Fourth, we add player nationality
	cell_icon = table_cell_icon.instantiate()
	var nation: Territory = GameMapManager.game_map.get_territory_by_id(player.Nationalities[0])
	cell_icon.display_data(nation.Name, nation.get_territory_image());
	row.add_child(cell_icon)
	
	# Fifth, we add shirt number
	cell = table_cell_text.instantiate();
	cell.display_data(str(player.Club_Shirt_Number));
	row.add_child(cell);

	# Sixth, we add
	cell = table_cell_text.instantiate();
	cell.display_data(str(player.Overall));
	row.add_child(cell);
	
	# Seventh, we add
	cell = table_cell_text.instantiate();
	cell.display_data(str(player.Potential));
	row.add_child(cell);
	
	cell = table_cell_text.instantiate();
	cell.display_data(str(player.Condition));
	row.add_child(cell);
	
	cell = table_cell_text.instantiate();
	cell.display_data(str(player.Morale));
	row.add_child(cell);
	
	cell = table_cell_text.instantiate();
	cell.display_data(str(player.Sharpness));
	row.add_child(cell);

func _on_column_button_clicked(column: String) -> void:
	# First we have to see if column selected is currently ascending or descending
	print(column)
