extends Node

""" Packed Scenes """
#const GAME_MAP_EDITOR: PackedScene = preload("res://Scenes/GameMapEditor/GameMapEditor.tscn")

""" File Saving and Loading Info """
var FileName : String; 
@onready var game_map: GameMap = GameMap.new();

""" ItemList """
@onready var team_list: ItemList = get_node("VBoxContainer/Editor Bar/VBoxContainer/Team List");
@onready var terr_list: ItemList = get_node("VBoxContainer/Editor Bar/Country List");


func _ready():
	load_game_map();
	load_default_territory_flags("C:/Team Logos", "");


"""
The following Functions Handle the  Loading of GameMaps
"""
func load_game_map():
	# Load the data saved in Disk
	var game_map_manager: GameMapManager = GameMapManager.new();
	var file_map : GameMap = game_map_manager.load_game_map_with_filename("selected_game_map") as GameMap;
	game_map = file_map;
	
	
	#Change the FileName to display what the name of file was, so user can see current GameMap open
	FileName =  "selected_game_map";
	var file_name_label: Label = get_node("VBoxContainer/Title Bar/FileName");
	file_name_label.text = FileName

	# Iter through each confed	
	for confed: Confederation in game_map.Confederations:
		# Skip World Confed
		if confed.Level != 1:
			continue
		
		# Add Confed Item, its not selectable and Gray Background
		var confed_name = confed.Name;
		var index: int = terr_list.add_item(confed_name, null, false);
		terr_list.set_item_custom_bg_color(index, Color(0.486, 0.416, 0.4));
		
		# Iterate through territoies
		confed.Territory_List.sort_custom(func(a: Territory, b: Territory): return a.Name.to_lower() < b.Name.to_lower())
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
			# Add to item list
			var terr_index: int = terr_list.add_item(terr_name, texture_normal, true);
			# Set Metadata
			terr_list.set_item_metadata(terr_index, terr);
			
			
	

	
"""
These functions deal with the ItemList for Teams
"""
func load_territory_teams(terr: Territory) -> void:
	#Clear itemlist
	team_list.clear();
	
	# Add National Team if territory has one
	if terr.National_Team != null:
		# Get team name and logo
		var team: Team = terr.National_Team
		var team_name = team.Name;
		var logo: Image = terr.get_territory_image();
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
	
	# Finally, we automatically select the team in the first position
	# Since each Territory has a national team, there will ALWAYS be at least one team per terrritory
	team_list.select(0, true)
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
	
	#Call Group to display teeam selected
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
	var terr: Territory = terr_list.get_item_metadata(selected_terr)
	
	#Store Default Information for a new Team in this territory
	team.Name = "Team Name"
	team.ID = -10;
	
	#Add it to itemlist
	var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
	var index = team_list.add_item(team.Name, default_icon, true);

	# Set Metadata
	team_list.set_item_metadata(index, team)
	
	# Add Team to GameMap
	game_map.add_team(team);
	
	# Add Team to Territory
	terr.add_club_team(team)
	
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
	var terr: Territory = terr_list.get_item_metadata(terr_list.get_selected_items()[0])

	# Delete the team from the Team List
	team_list.remove_item(team_id);
	
	# Delete from entire GameMap
	game_map.erase_team_by_id(team.ID);
	
	# Delete Team from Terr
	terr.remove_club_team(team)
	
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


func load_default_territory_flags(dir: String, store_dir: String) -> bool:
	# For now we want to clear the teams in the gamemap
	game_map.Teams.clear();
	for terr: Territory in game_map.Territories:
		terr.Club_Teams_Rankings.clear();
	
	#First we must make sure the the passed in directory even exists
	if not DirAccess.dir_exists_absolute(dir):
		return false
		
	# Now we can open it
	var team_logos_dir: DirAccess = DirAccess.open(dir)
	
	# Now we have to get the list of territories in this directory
	var dir_territories: PackedStringArray = team_logos_dir.get_directories();
	
	var local_teams: Array[Team] = []
	
	# Now for each territory we see if it has anything in the directory and save team logos present
	for terr: Territory in game_map.Territories:
		# We see if terr is present 
		if terr.Name not in dir_territories:
			print(terr.Name + " is not present!")
			continue
			
		# Now we have to go through the leagues of the territory
		var leagues: PackedStringArray = DirAccess.get_directories_at(dir + "/" + terr.Name)
		for league: String in leagues:
			# Now for each league we can either have the teams right away or split into groups, we behave different depending if groups are present
			var groups: PackedStringArray = DirAccess.get_directories_at(dir + "/" + terr.Name + "/" + league)
			if groups.size() > 0:
				# This means groups are present so we add them to the directories to iterate through 
				for group: String in groups:
					# Now we need to get the files in each group
					var team_logos: PackedStringArray = DirAccess.get_files_at(dir + "/" + terr.Name + "/" + league + "/" + group)
					for team_logo: String in team_logos:
						# First we create a new Team
						var team: Team = Team.new();
						team.Name = team_logo.get_file().get_basename();
						
						# Get image
						var logo: Image = Image.load_from_file(dir + "/" + terr.Name + "/" + league + "/" + group + "/" + team_logo)
						if logo != null:
							# Now we save logo
							team.save_image_for_team(logo);
						
						# Now add to GameMap
						local_teams.push_back(team)
						
						# Add Team to territory
						terr.Club_Teams_Rankings.push_back(team)
			else:
				# Now we need to get the files in each group
					var team_logos: PackedStringArray = DirAccess.get_files_at(dir + "/" + terr.Name + "/" + league)
					for team_logo: String in team_logos:
						# First we create a new Team
						var team: Team = Team.new();
						team.Name = team_logo.get_file().get_basename();
						
						# Get image
						var logo: Image = Image.load_from_file(dir + "/" + terr.Name + "/" + league + "/" + team_logo)
						if logo == null:
							print("Had issue with loading logo for " + team.Name)
							continue
							
							
						# Now we save logo
						team.save_image_for_team(logo);
						
						# Now add to GameMap
						local_teams.push_back(team)
						
						# Add Team to territory
						terr.Club_Teams_Rankings.push_back(team)
	
	game_map.add_teams(local_teams)
	return true

## Runs when the user clicks the "Go Back" Button, simply takes them back to the GameMap Editor. All changes here are saved to "selected_game_map.res" file
func _on_go_back_button_pressed():
	# First we must save the file to the selected_game_map file
	var game_map_manager: GameMapManager = GameMapManager.new();
	game_map_manager.save_game_map(game_map, "selected_game_map");
	
	# Now switch scenes
	#get_tree().change_scene_to_packed(GAME_MAP_EDITOR)
