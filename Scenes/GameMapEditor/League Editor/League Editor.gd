extends Control

""" GraphEdit """
@onready var graph_edit: GraphEdit = get_node("VBoxContainer/EditorBar/TabContainer/Tournament Editor");


""" Packed Scenes """
const GAME_MAP_EDITOR: PackedScene = preload("res://Scenes/GameMapEditor/GameMapEditor.tscn");

var FileName: String;



func _ready():
	load_game_map();

func load_game_map() -> void:
	# Load the data saved in Disk
	var game_map_manager: GameMapManager = GameMapManager.new();
	var file_map : GameMap = game_map_manager.load_game_map_with_filename("selected_game_map") as GameMap;
	get_node("VBoxContainer/EditorBar/TabContainer/Tournament Editor").game_map = file_map;
	
	#Change the FileName to display what the name of file was, so user can automatically
	#save changes easily
	FileName = file_map.Filename
	var file_name_label: Label = get_node("VBoxContainer/TitleBar/FileNameLabel");
	file_name_label.text = FileName
	
	var item_list: ItemList = get_node("VBoxContainer/EditorBar/NationList");

	
	# First we need to add all confederations as options
	var unselectable_item = item_list.add_item("Confederations", null, false);
	item_list.set_item_custom_bg_color(unselectable_item, Color(0.486, 0.416, 0.4));
	
	for confed: Confederation in file_map.Confederations:
		var confed_name = confed.Name;
		var index: int = item_list.add_item(confed_name, null, true);
		
		# Add to local list
		graph_edit.nation_list.set_item_metadata(index, confed);

	# Now we add all the territories
	unselectable_item = item_list.add_item("Territories", null, false);
	item_list.set_item_custom_bg_color(unselectable_item, Color(0.486, 0.416, 0.4));
	for terr: Territory in file_map.Territories:
		# Get Territory Name
		var terr_name = terr.Territory_Name;
		# Get Territory Flag or Icon
		var texture_normal
		var flag = terr.get_territory_image();
		if flag != null:
			flag.decompress();
			texture_normal = ImageTexture.create_from_image(flag);
		else:
			var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
			texture_normal = default_icon;
		# Add to item list
		var terr_index: int = item_list.add_item(terr_name, texture_normal, true);
		
		# Add to local list
		graph_edit.nation_list.set_item_metadata(terr_index, terr);
		
	
	#create_national_teams(file_map);
	# Add to dictionary to keep track
	graph_edit.game_map = file_map;

# DONT FORGET METADATA!!!!!
func _on_texture_button_pressed():
	get_node("LeagueLogoInput").visible = true;
								   

## When the User Presses the "Go Back to Menu" button. Changes the scene back to the GameMap Editor
func _on_button_pressed():
	# First we must save the file to the selected_game_map file
	var game_map_manager: GameMapManager = GameMapManager.new();
	game_map_manager.save_game_map(graph_edit.game_map, "selected_game_map");
	
	# Now switch scenes
	get_tree().change_scene_to_packed(GAME_MAP_EDITOR)
