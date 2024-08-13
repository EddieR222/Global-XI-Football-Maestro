extends Control

""" Country and Team Selection """
@onready var terr_selection: OptionButton = get_node("MarginContainer/VBoxContainer/TitleBar/CountrySelectionInput");
@onready var team_selection: OptionButton = get_node("MarginContainer/VBoxContainer/TitleBar/TeamSelectionInput");

var selected_terr: Territory;
var selected_team: Team;

""" Dialogs """
@onready var team_logo_file_dialog: FileDialog = get_node("TeamLogoFileDialg");

""" GameMap """
var gm: GameMap;

""" Player Tab """
var player_manager: PlayerManager;




# Called when the node enters the scene tree for the first time.
func _ready():
	# First thing we want to do is load the countries
	load_gamemap();
	
	# Get the Player Manager ready in case the player wants to generate players
	player_manager = PlayerManager.new(gm)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Load in the GameMap and Fill in Country Selection Option Button
func load_gamemap() -> void:
	# First we need to create an instance of GameMapManager
	var game_map_manager: GameMapManager = GameMapManager.new();
	
	# Now we simply load the selected_game_map.res
	var game_map: GameMap = game_map_manager.load_game_map_with_filename("selected_game_map");
	gm = game_map;
	
	# Now we need to load in the country list for the country option button
	# First we adjust the visuals for the popup menu
	var country_selection_popup: PopupMenu = terr_selection.get_popup();
	country_selection_popup.clear();
	country_selection_popup.add_theme_constant_override("icon_max_width", 25);
	country_selection_popup.add_theme_font_size_override("font_size", 25);
	
	# Also might as well adjust the visuals for the popup menu for team selection
	var team_selection_popup: PopupMenu = team_selection.get_popup();
	team_selection_popup.clear();
	team_selection_popup.add_theme_constant_override("icon_max_width", 25);
	team_selection_popup.add_theme_font_size_override("font_size", 25);
	
	# Now we load all the countries
	for confed: Confederation in game_map.Confederations:
		# We only want the level 1 confederations (like UEFA, AFC, CONMEBOL, etc..)
		if confed.Level != 1:
			continue
		
		# Sort territory list so each confed has their territories in alphabetical order
		confed.Territory_List.sort_custom(func(a: Territory, b: Territory): return a.Name.to_lower() < b.Name.to_lower());
		
		# Add Seperator to show when a new confed starts
		terr_selection.add_separator(confed.Name)
		
		# Now add all territories in confed
		for terr: Territory in confed.Territory_List:
			# Get Terr Flag
			var flag: Image = terr.get_territory_image();
			var texture: Texture2D;
			if flag != null:
				texture = ImageTexture.create_from_image(flag);
			else:
				var default_icon: CompressedTexture2D = load("res://Images/Icons/NO_FLAG_ICON.png");
				texture = default_icon;
				
			# Add terr to option button
			terr_selection.add_icon_item(texture, terr.Name)
			
			# Add Metadata for easier management (item added will also be added to end so we now -1 will work)
			terr_selection.set_item_metadata(-1, terr);
			
	# Now that we have added all confed and their territories, lets select the first country option by defacto
	terr_selection.select(1)
	terr_selection.item_selected.emit(1)
	
	return

""" Terr or Team Selected """

## Runs when the User Chooses a Country. Once the country is choosen, we need to load the club teams in the country
## into the option button.
func _on_country_selection_input_item_selected(index: int) -> void:
	# First we need to get the selected territory
	var terr: Territory = terr_selection.get_item_metadata(index)
	selected_terr = terr;
	
	# Now we need to load the club teams in the selected territory
	# First sort Teams by names and clear popup
	terr.Club_Teams_Rankings.sort_custom(func(a: Team, b: Team): return a.Name.to_lower() < b.Name.to_lower());
	team_selection.clear();
	
	# Second, add all teams to option button
	for team: Team in terr.Club_Teams_Rankings:
		# Get Team Logo
		var logo: Image = team.get_team_logo();
		var texture: Texture2D;
		if logo != null:
			texture = ImageTexture.create_from_image(logo);
		else:
			var default_icon: CompressedTexture2D = load("res://Images/Icons/NO_LOGO_ICON.png");
			texture = default_icon;
			
		# Add Team to Option Button
		team_selection.add_icon_item(texture, team.Name);
		
		# Add Team Resource as Metadata so management is easier
		team_selection.set_item_metadata(-1, team);
		
	# By Deafult, lets just choose the 1st choice in the team, that way there will always be a team chooosen
	# If, however, there are zero teams in the territory, then we need to set selected_team to null to signal there is currently no chosen team
	if team_selection.item_count > 0:
		team_selection.select(0);
		team_selection.item_selected.emit(0);
	else:
		selected_team = null;
	
	return

func _on_team_selection_input_item_selected(index: int) -> void:
	# First we need to get the selected team
	var team: Team = team_selection.get_item_metadata(index);
	
	# Now we set selected_team as the new team
	selected_team = team;
	
	# Display all the saved details for this selected team
	get_tree().call_group("T_Info", "team_selected", selected_team);

	return

""" Team Logo Input """
## This runs when the user clicks the Team Logo Button, this will simply open up the file dialog so the user can choose the image to use
func _on_logo_input_pressed() -> void:
	if selected_team != null:
		team_logo_file_dialog.visible = true;
	return

## This runs once the user actually chooses a Logo for the given team. This will get the image and save it in the Team
func _on_team_logo_file_dialg_file_selected(path: String) -> void:
	# Attempt to load in Image
	var logo: Image = Image.load_from_file(path);
	if logo != null:
		# If Logo was loaded successfully, save it and display
		selected_team.save_image_for_team(logo);
		get_tree().call_group("T_Info", "team_selected", selected_team);
	else:
		# If logo was not loaded successfully, give the user the option to retry or cancel
		# We do this by making the TeamLogoFailure prompt visible
		var team_logo_failure: AcceptDialog = get_node("TeamLogoFileDialg");
		team_logo_failure.visible = true;	
		
	return

## This runs if the user clicks to retry to load the Team Logo, we simply have to make the team logo file dialog visible again
func _on_team_logo_failure_confirmed():
	team_logo_file_dialog.visible = true;

""" Identity Tab Inputs """
func _on_team_name_input_text_changed(new_text: String) -> void:
	if selected_team != null:
		selected_team.Name = new_text;
	return
	
## Runs when the user changes the NickName of the team. Saves the new NickName in the Team Resource
func _on_nickname_input_text_changed(new_text: String) -> void:
	if selected_team != null:
		selected_team.Nickname = new_text;
	return




""" Player Tab Inputs """
func _on_generate_player_pressed() -> void:
	## Before we start generating players, we need to get the current option for the TeamList View
	var player_teamlist_view: OptionButton = get_node("MarginContainer/VBoxContainer/TabContainer/Players/HBoxContainer/PlayerListArea/TitleBar/PlayerViewOptions")
	var player_teamlist_view_id: int = player_teamlist_view.get_selected_id()
	if player_teamlist_view_id == -1:
		return
		
	var players: Array[Player];
	match player_teamlist_view_id:
		0: # Squad Only
			players = player_manager.generate_team_roster(selected_team.ID, 11);
		1: # Squad and Substitutes
			players = player_manager.generate_team_roster(selected_team.ID, 23);
		2: # Whole Team
			players = player_manager.generate_team_roster(selected_team.ID);
		3:
			players = player_manager.generate_team_roster(selected_team.ID, 10);
		4:
			players = player_manager.generate_team_roster(selected_team.ID, 10);
			
		
	
	pass # Replace with function body.
