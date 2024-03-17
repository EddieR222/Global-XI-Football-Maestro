extends GraphNode

@export var selected_index: int = -1;
var confed: Confederation = Confederation.new();
var game_map: GameMap;

""" ItemList """
@onready var item_list: ItemList = get_node("HBoxContainer/ItemList");

signal graphnode_selected(confed_id: int);
"""
This function allows another scene to get the territory info that is currently selected
"""
func get_selected_territory() -> Territory:
	var selected_territory: Territory = item_list.get_item_metadata(selected_index)
	return selected_territory;
	
func set_selected_territory(t: Territory) -> void:
	item_list.set_item_metadata(selected_index, t);
		
func set_confed_level(level: int):
	print("Level Received: " + str(level))
	confed.Level = level;
	
	var level_label: Label= get_node("HBoxContainer2/Label");
	level_label.text = "Level: " + str(confed.Level);
	
func set_confed(new_confed: Confederation) -> void:
	# First we set the confed 
	confed = new_confed;
	
	# Now we set the Line Edit to Reflect Confed Name
	var confed_name_edit: LineEdit = get_node("HBoxContainer2/LineEdit");
	confed_name_edit.text = confed.Name;
	
	# Now we set the confed level to what we had saved
	set_confed_level(new_confed.Level)
	
	# Now we simply add and item for each territory in territory list, clear if needed
	item_list.clear();
	for terr_id: int in new_confed.Territory_List:
		# Get Territory
		var terr: Territory = game_map.get_territory_by_id(terr_id);
		# Get Territory Name
		var terr_name = terr.Territory_Name;
		# Get Territory Flag or Icon
		var texture_normal
		var flag = terr.Flag;
		if flag != null:
			flag.decompress();
			texture_normal = ImageTexture.create_from_image(flag);
		else:
			var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
			texture_normal = default_icon;
		
		# Add to ItemList	
		var index: int = item_list.add_item(terr_name, texture_normal, true);
		
		# Set Metadata
		item_list.set_item_metadata(index, terr);
	

"""
These functions handle signls from within scene
"""

func _on_add_territory_pressed():
	# Add a blank territory item to ItemList
	var texture: CompressedTexture2D = load("res://Images/icon.svg");
	var index: int = $HBoxContainer/ItemList.add_item("Territory", texture, true);
	
	# For the item in the ItemList, we create the Territory
	var default_territory: Territory = Territory.new();
	default_territory.Territory_Name = "Territory"
	default_territory.CoTerritory_ID = -1;
	default_territory.Area = 0;
	default_territory.Population = 0;
	default_territory.Code = ""
	default_territory.GDP = 0;
	default_territory.Rating = 0;
	default_territory.League_Elo = 0;
	
	
	#var current_terr_num : int = node.world_map.get_territory_num() + 1;
	#print("Terr ID: " + str(current_terr_num))
	#default_territory.Territory_ID = current_terr_num;
	
	# Add New Territory to GameMap
	game_map.add_territory(default_territory);
	
	# Add it to Territory List
	confed.add_territory(default_territory.Territory_ID)
	
	# Here we want to set the Territory ID as the next value
	var node : GraphEdit = get_node("../../Confed Edit");
	node.world_graph.propagate_territory_addition(default_territory.Territory_ID, confed.ID);
	
	# Set Metadata
	item_list.set_item_metadata(index, default_territory);
	
	# Emit signal as button press counts as GraphNode selected
	graphnode_selected.emit(confed.ID);
	
	# Sort Item List
	item_list.sort_items_by_text();


func _on_delete_territory_pressed():
	# Make Confirmation Popup Visisble
	$ConfirmationDialog.visible = 1;
	
	# Emit signal as button press counts as GraphNode selected
	graphnode_selected.emit(confed.ID);

	
func reflect_territory_changes():
	# First, we sort the ids of the terr in stored in confed
	confed.Territory_List.sort();
	
	#We first need to go through and update the ItemList
	item_list.clear();
	for terr_id: int in confed.Territory_List:
		# Get Territory
		var terr: Territory = game_map.get_territory_by_id(terr_id);
		# Get Territory Name
		var terr_name = terr.Territory_Name;
		# Get Territory Flag or Icon
		var texture_normal
		var flag = terr.Flag;
		if flag != null:
			flag.decompress();
			texture_normal = ImageTexture.create_from_image(flag);
		else:
			var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
			texture_normal = default_icon;
		
		# Add to ItemList	
		var index: int = item_list.add_item(terr_name, texture_normal, true);
		
		# Set Metadata
		item_list.set_item_metadata(index, terr);

"""
The function below will alphabetize and reorganize the dictionary
"""
func _on_edit_territory_pressed():
	# Emit signal as button press counts as GraphNode selected
	graphnode_selected.emit(confed.ID);


func _on_item_list_item_selected(index):
	# Emit signal as button press counts as GraphNode selected
	graphnode_selected.emit(confed.ID);


func _on_line_edit_text_changed(new_text):
	# Save Name to Confed
	confed.Name = new_text;
	
	# Sort Confederations again, since the name of this confed has changed
	game_map.sort_confederations();
	
	# Emit signal as button press counts as GraphNode selected
	graphnode_selected.emit(confed.ID);


func _on_gui_input(event):
	# Emit signal as button press counts as GraphNode selected
	graphnode_selected.emit(confed.ID);
