extends Control


const CONFED_NODE : String = "res://Scenes/World Editor/Confederation Editors/Confederation Editor.tscn";
const TERRITORY_NODE : String = "res://Scenes/World Editor/Territory Editors/Territory Editor.tscn";


@export var Filename: String = ""


"""
Preload Nodes that we will instantiate later 
"""
@onready var confed_node: PackedScene = preload(CONFED_NODE);
@onready var terr_node: PackedScene = preload(TERRITORY_NODE);


"""
Functions below are responsible for saving and loading the WorldMap to user data. 
"""
func _on_save_file_pressed():
	# Init WorldMap Variable
	var save_map: GameMap = GameMap.new();
	
	# Get current GameMap
	save_map = get_node("VBoxContainer/Confed Edit").game_map;
	
	## Finally, save it to file
	var saver: GameMapManager = GameMapManager.new();
	saver.save_game_map(save_map, Filename);
	
	#ResourceSaver.save(save_map, "user://{filename}.res".format({"filename": Filename}), 32);
	
func _on_line_edit_text_changed(new_text: String):
	Filename = new_text;

func _on_load_file_pressed():
	$FileDialog.visible = true;

func _on_file_dialog_file_selected(path):
	# First we need to delete all nodes on screen
	#Get the Graph Edit Node
	var graph_edit: GraphEdit = get_node("VBoxContainer/Confed Edit");
	for node: GraphNode in graph_edit.world_graph.graph_nodes:
		node.queue_free();
		
	
	#Load the World Map from Disk
	var file_map : GameMap = ResourceLoader.load(path) as GameMap;
	#var file_map: GameMap = convert_to_new_image_system(file_start);

	# Start Graph Resource
	var world_map: WorldMapGraph = WorldMapGraph.new() 
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
			
			# Now we connect the territory edit node to the correct signals here
			graph_edit.connect_signals_from_territory_node(terr_edit_node);
			
			#Finally we add these nodes to the nodes tracker to be able to manpulate them later
			graph_edit.terr_edit_node = terr_edit_node;
			continue

		# For Non-World Nodes we do the normal things
		
		#Instantiate and add to scene tree
		var new_node: GraphNode = confed_node.instantiate(); 
		new_node.game_map = file_map
		graph_edit.add_child(new_node);
		#Enable Slots for Confed Node
		graph_edit.enable_slots(new_node);
		#Connect Needed Signals
		graph_edit.connect_signals_from_confed_node(new_node)
		# Set the new confed and display Name, Level, And Territories
		new_node.set_confed(confed)
		#Add it to graph_nodes to keep track of it
		world_map.add_node(new_node);

		
	# Redraw All Connections that were saved
	redraw_saved_connections(world_map, graph_edit);
	
	# Set Graph Edit's worl
	graph_edit.world_graph = world_map;
	graph_edit.game_map = file_map;
	
	# Arrange Nodes
	graph_edit.arrange_nodes();
	
	# Save all Images
	#convert_to_new_image_system(file_map);
	
	
func redraw_saved_connections(graph: WorldMapGraph, graph_edit: GraphEdit) -> void:
	# We iter through all trees and redraw connections
	for node: GraphNode in graph.graph_nodes:
		#We only iter levels down if node is starting node
		# we detect this by seeing if owner_id is -1 (applies for detached trees and world node)
		if node.confed.Owner_ID == -1:
			#We know we have a root node here, we have to iterate down now
			var queue: Array[GraphNode];
			var curr_node: GraphNode; 
			queue.push_back(node);
	
			while not queue.is_empty():
				# Pop node off queue
				curr_node = queue.pop_front();
				
				#Get Children of current node
				var children: Array = curr_node.confed.Children_ID;
				
				for child_id: int in children:
					# Add each child to queue
					var child_node: GraphNode = graph.graph_nodes[child_id];
					queue.push_back(child_node)
					
					#Connect Child to Owner
					graph_edit.connect_node(child_node.name, 0, curr_node.name, 0);
					
		else:
			continue;
			
			
