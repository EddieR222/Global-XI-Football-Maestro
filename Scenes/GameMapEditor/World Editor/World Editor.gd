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
	load_selected_gamemap();
	#pass



"""
Functions below are responsible for saving and loading the WorldMap to user data. 
"""
func load_selected_gamemap():
	#Load the World Map from Disk
	var game_map_manager: GameMapManager = GameMapManager.new();
	#var file_map : GameMap = game_map_manager.load_game_map_with_filename("selected_game_map")
	var file_map: GameMap = game_map_manager.get_csv_data();
	if file_map == null:
		return
		
	# First we need to delete all nodes on screen
	#Get the Graph Edit Node
	for node: GraphNode in graph_edit.world_graph.graph_nodes:
		node.queue_free();
	graph_edit.world_graph.graph_nodes.clear();

	# Start Graph Resource
	var world_map: WorldMapGraph = graph_edit.world_graph #WorldMapGraph.new() 
	world_map.game_map = file_map;
	
	
	# Iter through the confederations
	for confed: Confederation in file_map.Confederations:
		var world_confed_node: GraphNode
		# Establish Special World Node
		if confed.Level == 0:
			#Establish World Node
			world_confed_node = graph_edit.establish_world_node();
			world_confed_node.game_map = file_map
			world_confed_node.set_confed(confed);
			world_map.add_node(world_confed_node);
			
			#Establish Territory Edit
			var terr_edit_node: GraphNode = terr_node.instantiate();
			graph_edit.add_child(terr_edit_node);
			terr_edit_node.visible = false;
			terr_edit_node.game_map = file_map
			
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
		# Give the new node a copy of gamemap
		new_node.game_map = file_map
		#Add it to graph_nodes to keep track of it
		world_map.add_node(new_node);
		#Enable Slots for all added nodes
		graph_edit.enable_slots(new_node)

		
	# Redraw All Connections that were saved
	redraw_saved_connections(world_map, graph_edit);
	
	# Set Graph Edit's world
	graph_edit.world_graph = world_map;
	graph_edit.game_map = file_map;
	
	# Arrange Nodes
	graph_edit.arrange_nodes();
	
	# Set FileName
	get_node("VBoxContainer/HBoxContainer/FileName").text = file_map.Filename;
	
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
	# First we must save the file to the selected_game_map file
	var game_map_manager: GameMapManager = GameMapManager.new();
	game_map_manager.save_game_map(graph_edit.game_map, "selected_game_map");
	
	# Now switch scenes
	#get_tree().change_scene_to_packed(GAME_MAP_EDITOR)
	
