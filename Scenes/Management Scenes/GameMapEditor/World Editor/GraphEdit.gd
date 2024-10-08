extends GraphEdit

"""
All known issues still:
	Converting to more sustainable documentation and model of data retention
"""
@export var world_graph: WorldMapGraph = WorldMapGraph.new();
@export var curr_node_selected: GraphNode;
@export var curr_node_open_edit: GraphNode;

 
"""
Preload Nodes that we will instantiate later 
"""
@onready var confed_node: PackedScene = preload("res://Scenes/Management Scenes/GameMapEditor/World Editor/Confederation Editors/Confederation Editor.tscn");
@onready var terr_node: PackedScene = preload("res://Scenes/Management Scenes/GameMapEditor/World Editor/Territory Editors/Territory Editor.tscn");

""" Terr Edit Node """
## The local graph node for territory editor
@export var terr_edit_node: GraphNode;
	
# Called when the node enters the scene tree for the first time.
func _ready():
	# For testing
	GameMapManager.game_map = GameMap.new() #GameMapManager.get_csv_data();
	
	#if worked:
		#print(true)
	if GameMapManager.game_map.Confederations.size() == 0:
		# We want to establish the world node and ensure it has the right properties
		var world_confed_node: GraphNode = establish_world_node(false);
		
		# We also have to instantiate the country editor, there will only be one in the entire document and it will follow 
		# the confederation node that activated it.
		var new_terr_edit_node: GraphNode = terr_node.instantiate();
		add_child(new_terr_edit_node);
		new_terr_edit_node.visible = 0;
		
		# Now we connect the territory edit node to the correct signals here
		connect_signals_from_territory_node(new_terr_edit_node);
		
		#Finally store these to be ablet to manipulate later
		terr_edit_node = new_terr_edit_node
		world_graph.add_node(world_confed_node)
		
		# Log that World Node and Territory Editor have been established
		LogDuck.d("Territory Editor and World Node have been added");
		
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#This means that is the territory editor is visible, we move it to edge of node that opened it
	if terr_edit_node.visible:
		terr_edit_node.position = curr_node_open_edit.position + Vector2(curr_node_open_edit.size.x, 0) * zoom;
	
		
func establish_world_node(gm: bool) -> GraphNode:
	#First we simply instantiate the Node into the scene tree
	var world_confed_node: GraphNode = confed_node.instantiate();
	add_child(world_confed_node);
	world_confed_node.position_offset.x = get_viewport().get_mouse_position().x
	
	# This function sets some values such as confed text, level number, and connections
	world_confed_node.set_as_world_node();
	
	
	# Here we connect all needed signals
	connect_signals_from_confed_node(world_confed_node);
	
	# Now we make the confederation info for this node which will be stored in WorldMap;
	var world_confed_info = Confederation.new(); 
	world_confed_info.Level = 0;
	world_confed_info.Owner = -1;
	world_confed_info.Name = "World"
	
	# Update the info into GraphNode info
	world_confed_node.confed = world_confed_info;
	
	# Give it GameMap
	if not gm:
		GameMapManager.game_map.add_confederation(world_confed_info)
	
	# Finally return the world node
	return world_confed_node

func connect_signals_from_confed_node(node: GraphNode) -> void:
	# Here we connect the mouse_entered signal so selection is based on the player mouse entering the node area
	# This allows buttons or text typing to alert the selection and not mandate the user from having to select the node itself
	node.graphnode_selected.connect(_on_node_entered);
	
	# Here we connect the edit territory button to this scene
	var edit_terr_button: Button = node.get_node("HBoxContainer/MarginContainer/VBoxContainer/Edit Territory")
	edit_terr_button.pressed.connect(_on_edit_territory_pressed);

	# Here we connect the line Edit text to this scene
	var confed_name_edit: LineEdit = node.get_node("HBoxContainer2/LineEdit");
	confed_name_edit.text_submitted.connect(_on_confed_name_changed);
	
	#Here we connect the selection of an itemlist to this scene
	var itemlist: ItemList = node.get_node("HBoxContainer/ItemList");
	itemlist.item_selected.connect(_on_territory_selected);
	
	#Here we connect the delete territory button
	var delete_confirmation = node.get_node("ConfirmationDialog")
	delete_confirmation.confirmed.connect(_on_deleted_confirmed);
	
func connect_signals_from_territory_node(node: GraphNode) -> void:
	# Here we connect the "Done" button from territory node
	var done_button: Button = node.get_node("VBoxContainer2/Done");
	done_button.pressed.connect(_on_done_button_pressed);

"""
The following functions can be used to save and load territory information from
the territory edit node
"""
func save_territory() -> void:
	# First we need to grab the current territory information displayed on the territory edit node
	var curr_territory: Territory = terr_edit_node.get_territory();
	
	# Display changes to itemlist
	curr_node_open_edit.set_selected_territory(curr_territory);
	
	#Sort all Territories
	GameMapManager.game_map.sort_territories();
	
	# Now we need to display the changes in ItemList
	curr_node_open_edit.reflect_territory_changes();
	world_graph.propagate_territory_addition(curr_territory.ID, curr_node_open_edit.confed.ID);
	
func load_territory(selected_index: int ) -> void:
	# First we grab the territory info
	var terr: Territory = curr_node_open_edit.get_selected_territory();

	# Now we call the group in territory edit node in order to display this information
	terr_edit_node.load_previous_territory_info(terr);
	
"""
The following are Signal Handlers that pertain to the addition and deletion of confederations nodes
"""

## Called when we press the "ADD CONFEDERATION" button
## Creates the new node correctly and add its to scene tree
func _on_add_confed_node_pressed() -> void:
	
	# Get Node from preloaded scene, and add to tree
	var new_node: GraphNode = confed_node.instantiate(); 
	add_child(new_node);
	
	# Now we connect all needed signals 
	connect_signals_from_confed_node(new_node);
	var new_confed: Confederation = Confederation.new();
	new_confed.Name = "New Confederation";
	new_confed.Owner = -1;
	new_confed.Level = 1;
	
	# Add Confederation to GameMap
	GameMapManager.game_map.add_confederation(new_confed);
		
	# Now we set confed of graphnode
	new_node.confed = new_confed;

	# Add GraphNode to WorldMapGraph
	world_graph.add_node(new_node);
	
	# Make it by deault level 1
	new_node.set_confed_level(1);
	
	#Enable Slots for all added nodes
	enable_slots(new_node);
	
	# Log addition of confed and GraphNode
	LogDuck.d("Added new GraphNode with the following Confed: [color=green]Name: {name} | ID: {id} | Level: {level} | Owner: {owner}  ".format({"name": new_node.confed.Name, "id": new_node.confed.ID, "level": new_node.confed.Level, "owner": new_node.confed.Owner}))


## Called when we press the "DELETE CONFEDERATION" button
## Ensures we don't delete what we dont want to (ex: World Node, Territory Editor Node, etc)
## Then simply makes the confirmation dialog visible	
func _on_delete_node_pressed() -> void:
	# Validate A GraphNode is even selected
	if curr_node_selected == null:
		return
	
	# Validate GraphNode is not World Node;
	if curr_node_selected.confed.Level == 0:
		return
	
	# Validate Terr Edit Node isn't deleted
	if curr_node_selected == terr_edit_node:
		return
	
	# Makes the confirmation dialog box visible to the player
	get_node("../../ConfirmationDialog").visible = true;


## This is after the player presses "CONFIRM" on the confirmation dialog
## This confirms the user is willing to delete the confed node so here we actually delete it
func _on_confirmation_dialog_confirmed() -> void:
	# We need to delete all the territories that exist in the node
	var territory_list: Array[Territory] = curr_node_selected.confed.Territory_List;
	for terr: Territory in territory_list:
		if world_graph.has_lower_dependencies(terr.ID, curr_node_selected.confed.ID):
			# IF yes dependnce, only propagate deletion
			world_graph.propagate_territory_deletion(terr.ID, curr_node_selected.confed.ID);
		else:
			# If no dependence, delete and propagate deletion
			world_graph.propagate_territory_deletion(terr.ID, curr_node_selected.confed.ID);
			GameMapManager.game_map.erase_territory_by_id(terr.ID);
			
			
	# Remove GraphNode from graph
	var id: int = curr_node_selected.confed.ID
	world_graph.remove_node(id)
	
	# Erase Node from GameMap
	GameMapManager.game_map.erase_confederation_by_id(id);
	
	#Free the GraphNode
	curr_node_selected.free();
	
	# Set it equal to null, so next time we click a confed node we can set it to that
	curr_node_selected = null;
	
""" 
The following function handles 
"""

## This runs when the user clicks the "EDIT TERRITORY" button.
## This will make the Edit Territory Node visible and this node will follow the confed node that opened it until it is closed
func _on_edit_territory_pressed():
	#First we check that the territory edit isn't currently open, if it is open
	# then we do nothing as the user needs to close previous instance by pressing the 
	# "Done" button
	if terr_edit_node.visible:
		return
	
	# Now we check if curr_node_open_edit is null, if yes, then we know that we are allowed to open the edit territory scene again
	if curr_node_open_edit == null: 
		# Here, we know current node doesnt have a territory selected to open the edit territory node for
		if curr_node_selected.selected_index == -1:
			return
	else:
		# Here, we know some node has territory edit open
		if curr_node_open_edit != curr_node_selected:
			return
		if curr_node_open_edit.selected_index == -1:
			return 
		
	# Set open_node_edit as the currently selected node
	curr_node_open_edit = curr_node_selected;

	# This makes the territory editor visible
	terr_edit_node.visible = true;
	
	# Now we need to display the previously saved territory information
	var terr: Territory = curr_node_open_edit.get_selected_territory();
	terr_edit_node.load_previous_territory_info(terr);
	
## This function changes the name of the confederation when the uses changes the input in the LineEdit for the confederation Node
func _on_confed_name_changed(new_name: String) -> void:
	# First we get the confederation ID to track which node we will be changing
	curr_node_selected.confed.Name = new_name;
	
	

"""
This function runs when the done button is pressed
It saves the territory information and closes the Edit Territory Editor
"""
func _on_done_button_pressed():
	#Save territory info to required resources such as confed_node and world_map
	save_territory();
	
	# Now we make the edit territory node invisible
	terr_edit_node.visible = false;
	
	# Make selected index = -1;
	curr_node_open_edit.selected_index = -1;
	
	# Now we set node_open_edit to null to show that node_tracker isn't open and we are allowed to changed
	curr_node_open_edit.reflect_territory_changes();
	curr_node_open_edit.item_list.sort_items_by_text()
	curr_node_open_edit = null;

	
	
"""
This function switches the country info displayed on the Edit Territory Editor depending on which country the user selected.
Before switching, this functions saves the territory info being displayed and loads the next selected one 
"""
func _on_territory_selected(index: int) -> void:
	#First we need to check if current node selected has terr edit open
	
	if terr_edit_node.visible and curr_node_open_edit == curr_node_selected:
	# Now we know that the edit territory node is visible and we selected a territory
	# from the confed node that opened the territory node.
		#First we need to save current input from territory edit node
		save_territory();
		
		# Now we change the selected_index in the confed node
		curr_node_open_edit.selected_index = index;
		
		#Finally, we load the selected territory info onto the edit territory node
		load_territory(index);
	else:
		curr_node_selected.selected_index = index;	
"""
This function runs when the user clicks "Delete Territory - " Button and currently has a counry selected
"""
func _on_deleted_confirmed():
	# Makes the Edit Territory Editor Invisible
	terr_edit_node.visible = false;

	# IF Territory has lower dependences, then dont delete
	if world_graph.has_lower_dependencies(curr_node_selected.get_selected_territory().ID, curr_node_selected.confed.ID):
		get_node("../../AcceptDialog").visible = true;
		return
	
	# If no dependence, delete and propragte deletion
	world_graph.propagate_territory_deletion(curr_node_selected.get_selected_territory().ID, curr_node_selected.confed.ID);
	
	# Delete from Confed
	curr_node_selected.confed.delete_territory(curr_node_selected.get_selected_territory())
	
	# Delete from GameMap
	GameMapManager.game_map.erase_territory_by_id(curr_node_selected.get_selected_territory().ID)
	
	# Sort ItemList
	curr_node_selected.reflect_territory_changes()
	curr_node_selected.item_list.sort_items_by_text()
	



"""
The function below is used to enable slots for the confederation nodes. This allows connection between nodes
"""
func enable_slots(node: GraphNode):
	node.set_slot(0, true, 0, Color(0,1,0,1), true, 0,  Color(1,0,0,1), null, null, true)
	return
	
	
"""
This function handles connections between Confederation Nodes 
"""
func _on_connection_request(from_node, from_port, to_node, to_port):
	# This ensures a player doesn't try to connect a node to itself (which doesn't make sense)
	if from_node == to_node:
		# We log that the connection request was denied
		LogDuck.w("Connection Request Denied: Cannot Connect Node to itself")
		return
	
	# Next we need to ensure a node doesn't connect to a lower level node, essentially not create a cycle
	var curr_node_path: NodePath = NodePath(from_node);
	var owner_node_path: NodePath = NodePath(to_node);
	var curr_node: GraphNode = get_node(curr_node_path);
	var owner_node: GraphNode = get_node(owner_node_path);
	
	if curr_node.confed.Level != 1 or curr_node.confed.Owner != -1:
		#We are connecting already connected node, we need to ensure it doesn't connect down
		if owner_node.confed.Level >= curr_node.confed.Level:
			LogDuck.w("Connection Request Denied: Cannot Connect Nodes to Node of Lower Level")
			return
	if curr_node.confed.Owner != -1:
		LogDuck.w("Connection Request Denied: Cannot Connect already connected node")
		return
		
	# Ensure we don't exceed Confederation Level of 10
	var owner_level = owner_node.confed.Level
	if owner_level == 10:
		LogDuck.w("Reached Maximum Level of Confederations")
		return

	# Connect the nodes
	connect_node(from_node, from_port, to_node, to_port);
	
	#  Now we get the level that the from_node should be
	curr_node.set_confed_level(owner_level + 1);
	
	# Update Owner ID in Confed Node
	var curr_confed: Confederation = GameMapManager.game_map.get_confed_by_id(curr_node.confed.ID);
	curr_confed.Owner = owner_node.confed.ID;
	
	#Add curr_node to owner_node's children
	var owner_confed: Confederation = GameMapManager.game_map.get_confed_by_id(owner_node.confed.ID)
	owner_confed.Children.push_back(curr_node.confed)
	
	# Now we put the territory list into the owner confederation
	for terr: Territory in curr_confed.Territory_List:
		world_graph.propagate_territory_addition(terr.ID, curr_confed.ID)
		
		
	LogDuck.d("Connection Successful: \n\tChild: {name} | ID: {id} | Level: {level} | Owner: {owner} \n\tOwner: {owner_name} | ID: {owner_id} | Level: {owner_level} | Owner: {owner_owner}".format({"name": curr_confed.Name, "id": curr_confed.ID, "level": curr_confed.Level, "owner": curr_confed.Owner, "owner_name": owner_confed.Name, "owner_id": owner_confed.ID, "owner_level": owner_confed.Level, "owner_owner": owner_confed.Owner}));
	
func _on_disconnection_request(from_node, from_port, to_node, to_port):
	disconnect_node(from_node, from_port, to_node, to_port);


func clear_nodes_connections(from_node: StringName):
	# First we get all connections
	var connections: Array = get_connection_list();
	
	# Now we iterate and delete all connections
	for connection: Dictionary in connections:
		if connection["from_node"] == from_node:
			# Here we know this connection is connected to another node
			_on_disconnection_request(connection["from_node"], connection["from_port"], connection["to_node"], connection["to_port"]);
			continue
		if connection["to_node"] == from_node:
			_on_disconnection_request(connection["to_node"], connection["to_port"], connection["from_node"], connection["from_port"]);
			continue
	
"""
The two functions belows essentially decide and change the needed values when a GraphNode is selected or entered.
"""
func _on_node_entered(confed_id: int):
	# Update Node_Selected_NUm
	curr_node_selected = world_graph.get_node_by_id(confed_id);
	
	# Unselect every GraphNode in list
	for node: GraphNode in world_graph.graph_nodes:
		node.selected = false
	
	# Finally set new entered node as selected
	curr_node_selected.selected = true

func _on_node_selected(node: GraphNode):
	curr_node_selected = node


