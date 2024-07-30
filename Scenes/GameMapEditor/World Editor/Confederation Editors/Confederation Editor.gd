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
	# First we set the level of the confed stored
	confed.Level = level;
	
	# Second, we set the level saved to the text on the confed graph node
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
	for terr: Territory in new_confed.Territory_List:
		# Get Territory Name
		var terr_name = terr.Name;
		# Get Territory Flag or Icon
		var texture_normal
		var flag = terr.get_territory_image();
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
		
func set_as_world_node() -> void:
	# Now we name this Node as "World" and ensure this isn't changeable
	var confed_name_edit: LineEdit = get_node("HBoxContainer2/LineEdit");
	confed_name_edit.text = "World";
	confed_name_edit.editable = false;
	
	# Now we Edit the Level Number Label to show this node is the base node: "Level: 0"
	var label: Label = get_node("HBoxContainer2/Label")
	label.text = "Level: 0";
	
	# Now we enable the slots, simialr to other nodes but this one can't have connections OUT of but only IN
	set_slot(0, true, 0, Color(0,1,0,1), false, 0,  Color(1,0,0,1), null, null, true)
	
	return
"""
These functions handle signls from within scene
"""

## This functions runs when the user clicks "ADD TERRITORY" button on any confed node
func _on_add_territory_pressed():
	# Add a blank territory item to ItemList
	var texture: CompressedTexture2D = load("res://Images/icon.svg");
	var index: int = $HBoxContainer/ItemList.add_item("Territory", texture, true);
	
	# For the item in the ItemList, we create the Territory
	var default_territory: Territory = Territory.new();
	default_territory.Name = "Territory"
	default_territory.Area = 0;
	default_territory.Population = 0;
	default_territory.Code = ""
	default_territory.GDP = 0;
	default_territory.Rating = 0;
	default_territory.League_Elo = 0.0;
	
	# Add New Territory to GameMap
	game_map.add_territory(default_territory);
	
	# Add it to Territory List
	confed.add_territory(default_territory)
	
	# Log Territory
	LogDuck.d("Territory Added to Confed")
	
	# Here we want to set the Territory ID as the next value
	var node : GraphEdit = get_node("../../Confed Edit");
	node.world_graph.propagate_territory_addition(default_territory.ID, confed.ID);
	
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
	#We first need to go through and update the ItemList
	item_list.clear();
	for terr: Territory in confed.Territory_List:
		# Get Territory Name
		var terr_name = terr.Name;
		# Get Territory Flag or Icon
		var texture_normal
		var flag = terr.get_territory_image();
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
		
		
	item_list.sort_items_by_text();

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
