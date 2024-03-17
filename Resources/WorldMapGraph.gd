class_name WorldMapGraph extends Node

@export var graph_nodes: Array[GraphNode];
@export var game_map: GameMap;


"""
All functions below are for adding nodes and edges
"""
func add_node(new_node: GraphNode) -> void:
	# Validate Node
	if new_node == null:
		return
		
	# Ensure Node has name
	if new_node.confed.Name == null:
		return
	
	# Add to Array	
	graph_nodes.push_back(new_node)
		
	# Sort Graphnodes
	sort_graph_nodes();	
	

## Adds an edge between a to b
## This makes "B" the owner of "A" and "A" child of "B"
func add_edge(a: GraphNode, b: GraphNode) -> void:
	if a == null or b == null:
		return
	
	# Make B the Owner of A	
	a.confed.Owner_ID = b.confed.ID;

	# Make A the Child of B
	b.confed.Children_ID.push_back(a.confd.ID);

""" Removing or Erasing GraphNode """
## Removes the GraphNode at given index (confed_id)
## Automatically sorts and handles ids
func remove_node(confed_id: int) -> void:
	# Validate ID
	var node: GraphNode = get_node_by_id(confed_id);

	# Remove it from array
	if node != null:
		graph_nodes.erase(node);
	
	# Sort the Array and Organize Confederation IDs
	sort_graph_nodes();
	

""" Sorting the Confeds and GraphNodes """
## This Sorts the Graphnodes according to their underlying confederation id
func sort_graph_nodes() -> void:
	# Sort GraphNodes according to their confed id
	graph_nodes.sort_custom(func(a: GraphNode, b: GraphNode): return a.confed.ID < b.confed.ID)
	

""" Getter Functions """
## This function returns the GraphNode by id
func get_node_by_id(confed_id: int) -> GraphNode:
	# Validate ID
	if confed_id < 0 or confed_id >= graph_nodes.size():
		return null;
	
	# Return Requested GraphNode
	for node: GraphNode in graph_nodes:
		if node.confed.ID == confed_id:
			return node;
	
	return null
	
func get_territory_list(confed_id: int) -> Array[int]:
	# Validate ID
	var node: GraphNode = get_node_by_id(confed_id);
		
	# Return Requested Territory List
	if node != null:
		return node.confed.Territory_List;
		
	return [];
		
	
	
""" Boolean Functions """
## Returns bool of whether territory has lower dependencies
func has_lower_dependencies(terr_id: int, node_id: int) -> bool:
	
	var node: GraphNode = get_node_by_id(node_id);
	var confed: Confederation = node.confed;
	
	var childrens: Array[int] = confed.Children_ID;
	
	# Go through all children, and ensure they don't have lower dependencies
	for child: int in childrens:
		var curr_confed : Confederation = game_map.get_confed_by_id(child)
		
		if terr_id in curr_confed.Territory_List:
			return true
	
	return false






""" Functions that have to propagate the entire graph """
## This propagates the addition of a country up a list
func propagate_territory_addition(terr_id: int, node_id: int) -> void:
	# Validate IDs
	if terr_id < 0 or node_id < 0 or node_id >= graph_nodes.size():
		return
		
	# Get Desired node
	var curr_node: GraphNode = get_node_by_id(node_id);
	var curr_confed: Confederation
	# Setup Iteration Needs
	while curr_node.confed.Level >= 0:
		# Break when we reach end
		if curr_node.confed.Owner_ID == -1:
			break
			
			
		# Get Owner Node
		var owner_node: GraphNode = get_node_by_id(curr_node.confed.Owner_ID)
		
		# Place it in Owner if not already there
		if terr_id not in owner_node.confed.Territory_List:
			owner_node.confed.add_territory(terr_id)
			
		
		owner_node.reflect_territory_changes();
		curr_node = owner_node

func propagate_territory_deletion(terr_id: int, node_id: int) -> void:
	# Validate IDs
	if terr_id < 0 or node_id < 0 or node_id >= graph_nodes.size():
		return

	# Get Desired node
	var curr_node: GraphNode = get_node_by_id(node_id);
	var curr_confed: Confederation
	# Setup Iteration Needs
	while curr_node.confed.Level >= 0:
		# Break when we reach end
		if curr_node.confed.Owner_ID == -1:
			break
			
		# Get Owner Node
		var owner_node: GraphNode = get_node_by_id(curr_node.confed.Owner_ID)
		
		# Place it in Owner if not already there
		if terr_id in owner_node.confed.Territory_List:
			owner_node.confed.delete_territory(terr_id)
			
		owner_node.reflect_territory_changes();	
		curr_node = owner_node
