extends Control


const CONFED_NODE : String = "res://Scenes/GameMapEditor/World Editor/Confederation Editors/Confederation Editor.tscn";
const TERRITORY_NODE : String = "res://Scenes/GameMapEditor/World Editor/Territory Editors/Territory Editor.tscn";


"""
Preload Nodes that we will instantiate later 
"""
@onready var confed_node: PackedScene = preload(CONFED_NODE);
@onready var terr_node: PackedScene = preload(TERRITORY_NODE);


""" Packed Scene of GameMap Editor """
#const GAME_MAP_EDITOR: PackedScene = preload("res://Scenes/GameMapEditor/GameMapEditor.tscn");


@onready var graph_edit: GraphEdit = get_node("VBoxContainer/Confed Edit");

func _ready():
	# Here we want to load the "SelectedFile" file to load the selected GameMap in the GameMap Editor
	load_gamemap();
	#pass



"""
Functions below are responsible for saving and loading the WorldMap to user data. 
"""
func load_gamemap():	
	#Load the World Map from Disk
	var file_map : GameMap = GameMapManager.game_map
	#var file_map: GameMap = game_map_manager.get_csv_data();
	if file_map == null:
		return
		
	# First we need to delete all nodes on screen
	#Get the Graph Edit Node
	for node: GraphNode in graph_edit.world_graph.graph_nodes:
		node.queue_free();
	graph_edit.world_graph.graph_nodes.clear();

	# Start Graph Resource
	var world_map: WorldMapGraph = graph_edit.world_graph #WorldMapGraph.new() 
	
	
	# Iter through the confederations
	for confed: Confederation in file_map.Confederations:
		# Establish Special World Node
		if confed.Level == 0:
			#Establish World Node
			var world_confed_node: GraphNode
			world_confed_node = graph_edit.establish_world_node(true);
			world_confed_node.set_confed(confed);
			world_map.add_node(world_confed_node);
			
			#Establish Territory Edit
			var terr_edit_node: GraphNode = terr_node.instantiate();
			graph_edit.add_child(terr_edit_node);
			terr_edit_node.visible = false;
			
			# Now we connect the territory edit node to the correct signals here
			graph_edit.connect_signals_from_territory_node(terr_edit_node);
			
			#Finally we add these nodes to the nodes tracker to be able to manpulate them later
			graph_edit.terr_edit_node = terr_edit_node;
			continue

		# For Non-World Nodes we do the normal things
		
		#Instantiate and add to scene tree
		var new_node: GraphNode = confed_node.instantiate();
		graph_edit.add_child(new_node); 
		
		#Connect Needed Signals
		graph_edit.connect_signals_from_confed_node(new_node)
		# Set the new confed and display Name, Level, And Territories
		new_node.set_confed(confed)
		#Add it to graph_nodes to keep track of it
		world_map.add_node(new_node);
		#Enable Slots for all added nodes
		graph_edit.enable_slots(new_node)

		
	# Redraw All Connections that were saved
	redraw_saved_connections(world_map, graph_edit);
	
	# Set Graph Edit's world
	graph_edit.world_graph = world_map;
	
	# Arrange Nodes
	graph_edit.arrange_nodes();
	
	# Set FileName
	get_node("VBoxContainer/HBoxContainer/FileName").text = file_map.File_Name;
	
	# Now we sort all countries in all nodes
	for node: GraphNode in world_map.graph_nodes:
		# Get the item list of the GraphNode
		var item_list: ItemList = node.get_node("HBoxContainer/ItemList");
		
		# Now we just sort the coutnries in the itemlist
		item_list.sort_items_by_text();
	
func redraw_saved_connections(graph: WorldMapGraph, graph_edit: GraphEdit) -> void:
	# We iter through all trees and redraw connections
	for curr_level: int in range(1, 10):
		for node: GraphNode in graph.graph_nodes:
			# First we check we are at the right level
			if node.confed.Level != curr_level or node.confed.Owner == -1:
				continue
				
			# Now we know the node has an owner
			# Finally, we just connect them
			var owner_node: GraphNode = graph.get_node_by_id(node.confed.Owner);	
			graph_edit.connect_node(node.name, 0, owner_node.name, 0);


## When the user wants to go back to the Main GameMap Editor Menu
func _on_go_back_button_pressed():
	# Before we do anything, we must first go through and validate the territories and confederations
	var error_message: String = "Please Fix the Following Errors Before Saving:"
	
	# 1. Make sure all confed nodes are connected to the world node
	for node: GraphNode in graph_edit.world_graph.graph_nodes:
		if not graph_edit.world_graph.connected_to_world_node(node.confed.ID):
			error_message += "\n\t- {name}: Not Connected to World Node in some way".format({"name": node.confed.Name});
		
	# 2. Every Territory needs the bare minimum of one first and last names and a country rating of > 0
	# we also want to ensure no Territory is simply named Territory (meaning the user didn't give it a name)
	for terr: Territory in GameMapManager.game_map.Territories:
		if terr.First_Names.size() < 1:
			error_message += "\n\t- {name}: Needs at Least One First Name".format({"name": terr.Name})
		if terr.Last_Names.size() < 1:
			error_message += "\n\t- {name}: Needs at Least One Last Name".format({"name": terr.Name})
		if terr.Rating < 1:
			error_message += "\n\t- {name}: Needs at Least A Country Rating of >1".format({"name": terr.Name})
		if terr.Name == "Territory":
			error_message += "\n\t- {name}: Needs a valid Country Name".format({"name": terr.Name})
	
	# Now, if any error was detecting, we need to exit early and display the errors
	if error_message != "Please Fix the Following Errors Before Saving:":
		var error_dialog: AcceptDialog = get_node("ScrollContainer/Error");
		
		# Give it Error Messages
		error_dialog.dialog_text = error_message
		
		# Make it visible
		error_dialog.visible = true
		
		# Exit Function Early
		return
	
	# First we must save the file to the selected_game_map file
	GameMapManager.save_game_map();
	
	# Now switch scenes
	#get_tree().change_scene_to_packed(GAME_MAP_EDITOR)
	
