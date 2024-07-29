extends GutTest
## This file has some unit test for testing that Confederation Addition works as expected

class TestConfederationNodeAddition:
	extends GutTest
	
	var edit: GameMap = null;
	var world_graph: WorldMapGraph = null;
	const CONFED_NODE : String = "res://Scenes/GameMapEditor/World Editor/Confederation Editors/Confederation Editor.tscn";
	@onready var confed_node: PackedScene = preload(CONFED_NODE);
	
	func before_each():
		# First we need to establish the GameMap and WorldGraph so we can test the addition of Confederations
		edit = GameMap.new();
		world_graph = WorldMapGraph.new();
		
		# Now we need to simply establish a world node since it is required to have in every Gamemap
		var world_confed_node: GraphNode = confed_node.instantiate();
		var world_confed_info = Confederation.new(); 
		world_confed_info.Level = 0;
		world_confed_info.Owner = -1;
		world_confed_info.Name = "World"
		
		# Update the info into GraphNode info
		world_confed_node.confed = world_confed_info;
		
		# Give it GameMap
		edit.add_confederation(world_confed_info)
		world_confed_node.game_map = edit
		world_graph.add_node(world_confed_node)
