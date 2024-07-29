extends Node

""" Packed Scenes """
const GAME_MAP_EDITOR: PackedScene = preload("res://Scenes/GameMapEditor/GameMapEditor.tscn")

""" File Saving and Loading Info """
var FileName : String; 
@onready var game_map: GameMap = GameMap.new();

""" ItemList """
@onready var team_list: ItemList = get_node("VBoxContainer/Editor Bar/VBoxContainer/Team List");
@onready var terr_list: ItemList = get_node("VBoxContainer/Editor Bar/Country List");


func _ready():
	load_game_map();


"""
The following Functions Handle the Saving and Loading of Files
"""

func _on_save_file_pressed():
	print("Saving..")
	
	# Sort teams before saving
	game_map.sort_teams();
	
	var saver: GameMapManager = GameMapManager.new();
	
	# Finally, save it to file
	saver.save_game_map(game_map, FileName);

	
func load_game_map():
	# Load the data saved in Disk
	var game_map_manager: GameMapManager = GameMapManager.new();
	var file_map : GameMap = game_map_manager.load_game_map_with_filename("selected_game_map") as GameMap;
	game_map = file_map;
	
	
	#Change the FileName to display what the name of file was, so user can automatically
	#save changes easily
	FileName =  "selected_game_map";
	var file_name_label: Label = get_node("VBoxContainer/Title Bar/FileName");
	file_name_label.text = FileName

	# Iter through each confed	
	for confed: Confederation in game_map.Confederations:

		if confed.Level != 1:
			continue
		# Add Confed Item, its not selectable and Gray Background
		var confed_name = confed.Name;
		var index: int = terr_list.add_item(confed_name, null, false);
		terr_list.set_item_custom_bg_color(index, Color(0.486, 0.416, 0.4));
		
		# Iterate through territoies
		for terr: Territory in confed.Territory_List:
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
			var terr_index: int = terr_list.add_item(terr_name, texture_normal, true);
			# Set Metadata
			terr_list.set_item_metadata(terr_index, terr);
			
			
	

func _on_line_edit_text_changed(new_text: String):
	FileName = new_text
	
"""
These functions deal with the ItemList for Teams
"""
func load_territory_teams(terr: Territory) -> void:
	#Clear itemlist
	team_list.clear();
	
	# Add National Team if territory has one
	#if terr.National_Team != -1:
		#var team: Team = game_map.get_team_by_id(terr.National_Team);
		## Get team name and logo
		#var team_name = team.Name;
		#var logo: Image = team.get_team_logo();
		#var texture_normal
		#if logo != null:
			#logo.decompress();
			#texture_normal = ImageTexture.create_from_image(logo);
		#else:
			#var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
			#texture_normal = default_icon;
			#
		## Add Team to Item List
		#var index: int = team_list.add_item(team_name, texture_normal, true);
		## Set Metadata for item
		#team_list.set_item_metadata(index, team);
		#

	# Now add all teams in territory selected
	for team: Team in terr.Club_Teams_Rankings:
		# Get team name and logo
		var team_name = team.Name;
		var logo: Image = team.get_team_logo();
		var texture_normal
		if logo != null:
			logo.decompress();
			texture_normal = ImageTexture.create_from_image(logo);
		else:
			var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
			texture_normal = default_icon;
			
		# Add Team to Item List
		var index: int = team_list.add_item(team_name, texture_normal, true);
		# Set Metadata for item
		team_list.set_item_metadata(index, team);

	#Once we have added all teams, simply sort
	team_list.sort_items_by_text();
"""
The function below are to change the index when the user selects a new territory or team
"""
func _on_country_list_item_selected(index: int) -> void:
	# Get Selected Territory and display them to Item List
	var selected_terr: Territory = terr_list.get_item_metadata(index);
	load_territory_teams(selected_terr);
	
	#if selected_terr.Club_Teams_Rankings.is_empty():
		#automatic_team_upload(selected_terr)
	
func _on_team_list_item_selected(index: int) -> void:
	#We need to display the territory selected
	var team: Team = team_list.get_item_metadata(index)
	
	#Call Group to display territory
	get_tree().call_group("Team_Info", "team_selected", team)
	
	# We also need to relfect any logo, team_name, or ID changes to previously selected teams
	#game_map.sort_teams();
	reflect_team_changes();

func reflect_team_changes() -> void:
	# Now add all teams in territory selected
	for team_id: int in range(team_list.item_count):
		var team: Team = team_list.get_item_metadata(team_id);
		# Get team name and logo
		var team_name = team.Name;
		var logo: Image = team.get_team_logo();
		var texture_normal
		if logo != null:
			logo.decompress();
			texture_normal = ImageTexture.create_from_image(logo);
		else:
			var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
			texture_normal = default_icon;
		# Set Item Text
		team_list.set_item_text(team_id, team_name)
		# Set Item Logo
		team_list.set_item_icon(team_id, texture_normal) 
	
 


"""
The functions below are responcible for adding and deleting teams from Team List
"""
func _on_add_team_pressed() -> void:
	# If user hasn't selected a territory to save this new team in, return early
	if terr_list.get_selected_items().is_empty():
		return
	
	var selected_terr: int = terr_list.get_selected_items()[0];
	
	# Create new Team Object
	var team: Team = Team.new();
	
	#Get currently selected Territory
	var terr: Territory = game_map.get_territory_by_id(selected_terr); ##ALERT; Change this to get metadata as we have empty items on itemlist
	
	#Store Default Information for a new Team in this territory
	team.Name = "Team Name"
	team.Territory_Name = terr.Territory_Name;
	team.Territory_ID = terr.Territory_ID;
	team.ID = game_map.Teams.size();
	
	#Add it to itemlist
	var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
	var index = team_list.add_item(team.Name, default_icon, true);

	# Set Metadata
	team_list.set_item_metadata(index, team)
	
	# Add Team to GameMap
	game_map.add_team(team);
	
	#Reflect Changes
	reflect_team_changes();
	team_list.sort_items_by_text();
	
func _on_delete_team_pressed():
	get_node("Delete Team Confirmation").visible = true

func _on_confirmation_dialog_confirmed():
	# No team or territory selected means we won't delete any team, return early
	if team_list.get_selected_items().is_empty() or terr_list.get_selected_items().is_empty():
		return
		
	# Get Selected Team ID
	var team_id: int = team_list.get_selected_items()[0];
	var team: Team = team_list.get_item_metadata(team_id);

	# Delete the team from the Team List
	team_list.remove_item(team_id);
	
	# Delete from entire GameMap
	game_map.erase_team_by_id(team.ID);
	
	reflect_team_changes();
	team_list.sort_items_by_text();

""" Functions for Team Info Inputs"""
func _on_logo_pressed():
	if team_list.get_selected_items().is_empty():
		return
	
	$"Logo File Dialog".visible = true;
func _on_logo_file_dialog_file_selected(path) -> void:
	# Load Image of Team Logo
	var logo: Image = Image.load_from_file(path);
	logo.resize(150, 150, 2);
	var logo_texture: ImageTexture = ImageTexture.create_from_image(logo);
	
	# Change Texture of Texture Button to reflect change
	$"VBoxContainer/Editor Bar/Middle/HBoxContainer/Logo".texture_normal = logo_texture
	
	# Now we want to reflect logo change
	var team_id: int = team_list.get_selected_items()[0];
	team_list.set_item_icon(team_id, logo_texture);
	
	# Save Image into Team 
	var team: Team = team_list.get_item_metadata(team_id);
	team.save_image_for_team(logo)
	
	
func _on_team_name_text_changed(new_text: String) -> void:
	# First ensure team and nation are selected
	if team_list.get_selected_items().is_empty():
		return

	#Save to local Database
	var selected_index: int = team_list.get_selected_items()[0];
	var team: Team = team_list.get_item_metadata(selected_index)
	team.Name = new_text;

	reflect_team_changes();
func _on_name_code_input_text_changed(new_text: String) -> void:
	# First ensure team and nation are selected
	if team_list.get_selected_items().is_empty():
		return

	#Save to local Database
	var selected_index: int = team_list.get_selected_items()[0];
	var team: Team = team_list.get_item_metadata(selected_index)
	team.Name_Code = new_text
func _on_city_input_text_changed(new_text: String) -> void:
	# First ensure team and nation are selected
	if team_list.get_selected_items().is_empty():
		return

	#Save to local Database
	var selected_index: int = team_list.get_selected_items()[0];
	var team: Team = team_list.get_item_metadata(selected_index)
	team.City = new_text
func _on_spin_box_value_changed(value: int) -> void:
	# First ensure team and nation are selected
	if team_list.get_selected_items().is_empty():
		return

	#Save to local Database
	var selected_index: int = team_list.get_selected_items()[0];
	var team: Team = team_list.get_item_metadata(selected_index)
	team.Rating = value
#func automatic_team_upload(terr: Territory) -> void:
	##First we must load in the SQL Database
	#var database = SQLite.new();
	#database.path = "C:/Rust_Projects/FootballProject/Team Breakdown.db"
	#database.open_db();	
	#
	#
	## Now we need to get each row
	#var result = database.select_rows("team_data", "Nation = '" + terr.Territory_Name + "'", ["*"]);
	#for team_info: Dictionary in result:
		## For each team_infp, we need to create a team
		#var team: Team = Team.new();
		#
		## Now we need to add the team info from the sql database
		#team.Name = team_info["Team_Name"];
		#
		## Add it to gamemap
		#game_map.add_team(team)
		#
		#var nation: String = terr.Territory_Name
		#team.Territory_Name = terr.Territory_Name
		#team.Territory_ID = terr.Territory_ID
			#
		#
		## Now we add team logo if we have it
		#var index = team_info["index"];
		#var path = "C:/Rust_Projects/Team_Logos/" + str(index) + ".png";
		#
		#if FileAccess.file_exists(path):
			#var logo: Image = Image.load_from_file(path);
			#if logo != null:
				#logo.resize(150, 150, 2);
				#team.save_image_for_team(logo)
		##Finally, we add it to respective country list
		## Add it to terr club rankings
		#terr.Club_Teams_Rankings.push_back(team.ID);
			#

		


## Runs when the user clicks the "Go Back" Button, simply takes them back to the GameMap Editor. All changes here are saved to "selected_game_map.res" file
func _on_go_back_button_pressed():
	# First we must save the file to the selected_game_map file
	var game_map_manager: GameMapManager = GameMapManager.new();
	game_map_manager.save_game_map(game_map, "selected_game_map");
	
	# Now switch scenes
	get_tree().change_scene_to_packed(GAME_MAP_EDITOR)
