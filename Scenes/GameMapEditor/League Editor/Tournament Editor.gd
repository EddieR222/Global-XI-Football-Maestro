extends GraphEdit


""" Paths for Node Scenes """
const LEAGUE_NODE: String = "res://Scenes/GameMapEditor/League Editor/Tournament Nodes/LeagueNode.tscn";
const GROUPSTAGE_NODE: String = "res://Scenes/GameMapEditor/League Editor/Tournament Nodes/GroupStageNode.tscn";
const KNOCKOUT_NODE: String = "res://Scenes/GameMapEditor/League Editor/Tournament Nodes/KnockoutNode.tscn";
const SINGLE_KNOCKOUT_NODE: String = "res://Scenes/GameMapEditor/League Editor/Tournament Nodes/SingleKnockOutNode.tscn";


""" Packed Scenes of GraphNode """
@onready var league_node: PackedScene = preload(LEAGUE_NODE);
@onready var groupstage_node: PackedScene = preload(GROUPSTAGE_NODE);
@onready var knockout_node: PackedScene = preload(KNOCKOUT_NODE);
@onready var single_knockout_node: PackedScene = preload(SINGLE_KNOCKOUT_NODE);

""" ItemLists """
# Nation List
@onready var nation_list: ItemList = get_node("../../NationList");
var curr_nation;
# League Pyramid List
@onready var league_pyramid: ItemList = get_node("../Territory League Pyramid/League Pyramid Area/League Pyramid")
var curr_league: Tournament;
# Tournament List
@onready var tournament_list: ItemList = get_node("../Territory Tournaments/Tournament List Area/Tournament List")
var curr_tournament: Tournament;

""" PopUp Menus """
@onready var add_node_popmenu: PopupMenu = get_node("../../../TitleBar/AddLeagueStage").get_popup();
@onready var tour_select = get_node("../../../TitleBar/TournamentSelection");
@onready var tour_select_popmenu: PopupMenu = get_node("../../../TitleBar/TournamentSelection").get_popup();

""" Constants """
const NODE_SIZE: Vector2 = Vector2(600, 525);
var DAYS: Dictionary = {"JANUARY": 31, "FEBRUARY": 28, "MARCH": 31, "APRIL": 30, "MAY": 31, "JUNE":30, "JULY": 31, "AUGUST": 31, "SEPTEMBER": 30, "OCTOBER": 31, "NOVEMBER":30, "DECEMBER":31};
const DEFAULT_ITEMLIST_COLOR: Color = Color(0.1, 0.1, 0.1);
const DOMESTIC_CUP_COLOR: Color = Color(0.2, 0.4, 0.8);
const SUPER_CUP_COLOR: Color = Color(0.2, 0.8, 0.4)

""" Members """
var game_map: GameMap = GameMap.new();

""" """


# Called when the node enters the scene tree for the first time.
func _ready():
	configure_pop_menus()

func configure_pop_menus() -> void:
	#First we need to set up the popup menu from the Add League Stage
	add_node_popmenu.id_pressed.connect(_on_add_stage_popmenu_item_selected);
	
	#Make icons size smaller for popupmenu
	tour_select_popmenu.add_theme_constant_override("icon_max_width", 25);
	
	# Second we need to set up the select tournament popup
	tour_select_popmenu.id_pressed.connect(_on_tournament_selected);

func _on_tournament_selected(index: int) -> void:
	pass
	
func load_tournaments(source) -> void:
	# First we clear the current list
	tour_select.select(-1)
	tour_select_popmenu.clear();
	league_pyramid.clear();
	tournament_list.clear();

	var leagues: Array
	var tournaments: Array
	var super_cup_index: int;
	var league_cup: int;
	if source is Territory:
		# Load needed variables
		leagues= source.Leagues;
		tournaments = source.Tournaments;
		super_cup_index= source.Super_Cup;
		league_cup = source.League_Cup;
	elif source is Confederation:
		leagues = source.Confed_Leagues;
		tournaments = source.Confed_Tournaments;
		super_cup_index = source.Super_Cup;
		league_cup = source.Cup;
		
		
	# Now we need to load them into the needed itemlists
	# First we load the league pyramid
	for league_id: int in leagues:
		# Get League
		var league: Tournament = game_map.get_tournament_by_id(league_id); 
		# Get Tournament Name
		var league_name = league.Name;
		# Get Tournament Logo
		var texture_normal
		var logo = league.Logo;
		if logo != null:
			logo.decompress();
			texture_normal = ImageTexture.create_from_image(logo);
		else:
			var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
			texture_normal = default_icon;
		# Add it to item list
		var index = league_pyramid.add_item(league_name, texture_normal, true);
		# Save it to local list  
		league_pyramid.set_item_metadata(index, league);
		
	# Second we load the other tournaments
	for tour_id: int in tournaments:
		# Get Tournament
		var tournament: Tournament = game_map.get_tournament_by_id(tour_id);
		# Get Tournament Name
		var league_name = tournament.Name;
		# Get Tournament Logo
		var texture_normal
		var logo = tournament.Logo;
		if logo != null:
			logo.decompress();
			texture_normal = ImageTexture.create_from_image(logo);
		else:
			var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
			texture_normal = default_icon;
		# Add it to item list
		var index = tournament_list.add_item(league_name, texture_normal, true);
		#Save to local list
		tournament_list.set_item_metadata(index, tournament);
		
		#We have to highlight super cup and leagues cup
		if index == super_cup_index:
			tournament_list.set_item_custom_bg_color(index, Color(0.486, 0.416, 0.4));
		elif index == league_cup:
			tournament_list.set_item_custom_bg_color(index, Color(0.486, 0.416, 0.0));
	
	#update_tournament_selection_popup();
		#
#func update_tournament_selection_popup() -> void:
	#if curr_nation == null:
		#return
		#
	## Clear the popup menu
	#tour_select_popmenu.clear();	
		#
	#var leagues: Dictionary
	#var tournaments: Dictionary
	#var super_cup_index: int;
	#var league_cup: int;
	#if curr_nation is Territory:
		## Load needed variables
		#leagues= curr_nation.Leagues;
		#tournaments = curr_nation.Tournaments;
		#super_cup_index= curr_nation.Super_Cup;
		#league_cup = curr_nation.League_Cup;
	#elif curr_nation is Confederation:
		#leagues = curr_nation.Confed_Leagues;
		#tournaments = curr_nation.Confed_Tournaments;
		#super_cup_index = curr_nation.Super_Cup;
		#league_cup = curr_nation.Cup;
		#
		#
	## Now we need to load them into the needed itemlists
	## First we load the league pyramid
	#for league: Tournament in leagues.values():
		## Get Tournament Name
		#var league_name = league.Name;
		## Get Tournament Logo
		#var texture_normal
		#var logo = league.Logo;
		#if logo != null:
			#logo.decompress();
			#texture_normal = ImageTexture.create_from_image(logo);
		#else:
			#var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
			#texture_normal = default_icon;
		## Add it to popup menu
		#tour_select_popmenu.add_icon_item(texture_normal, league_name);
		## Save it to local list  
		##league_pyramid.set_item_metadata(index, league);
		#
	## Second we load the other tournaments
	#for tournament: Tournament in tournaments.values():
		## Get Tournament Name
		#var tournament_name = tournament.Name;
		## Get Tournament Logo
		#var texture_normal
		#var logo = tournament.Logo;
		#if logo != null:
			#logo.decompress();
			#texture_normal = ImageTexture.create_from_image(logo);
		#else:
			#var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
			#texture_normal = default_icon;
		## Add it to item list
		#tour_select_popmenu.add_icon_item(texture_normal, tournament_name)
		##Save to local list
		##tournament_list.set_item_metadata(index, tournament);
	#

""" Functions for when user selects in an item list """
func _on_nation_list_item_selected(index: int) -> void:
	# Save curr confed/terr to var
	curr_nation = nation_list.get_item_metadata(index)
	# Load the New Selected Territory's or Confederation's tournament
	load_tournaments(curr_nation);
	
	# Make curr_league and curr_tournament null to show they aren't selected yet
	curr_league = null;
	curr_tournament = null;

func _on_league_pyramid_item_selected(index: int) -> void:	
	curr_league = league_pyramid.get_item_metadata(index);
	# Display selected league's info
	get_tree().call_group("League_Info", "league_selected", curr_league);

func _on_tournament_list_item_selected(index: int) -> void:
	#Set curr_tournament 
	curr_tournament = tournament_list.get_item_metadata(index);
	# Display selected tournament info
	get_tree().call_group("Tour_Info", "tour_selected", curr_tournament);
	
""" Item Lists Addition and Deletion """
func _on_add_league_level_pressed():
	if curr_nation == null:
		return
		
	# Create a new Tournament for the league
	var new_tour: Tournament = Tournament.new();
	new_tour.Name = "New Tournament"
			
	# Save it to GameMap
	game_map.add_tournament(new_tour);
	
	# Save it to the terr/confed selected
	var sink = curr_nation
	if sink is Territory:
		sink.Leagues.push_back(new_tour.ID)
	elif sink is Confederation:
		sink.Confed_Leagues.push_back(new_tour.ID)
	
	# Add it to the league pyramid
	var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
	var index = league_pyramid.add_item("New Tournament", default_icon, true);
	league_pyramid.set_item_metadata(index, new_tour);
	
	# Sort ItemList
	league_pyramid.sort_items_by_text();
	
	#update_tournament_selection_popup();

func _on_delete_league_level_pressed():
	# Get index of selected item
	var selected_index_list = league_pyramid.get_selected_items();
	var index: int;
	# If none are selected, return early
	if selected_index_list.is_empty():
		return
	else:
		index = selected_index_list[0];
		
	# Get tournament
	var tour: Tournament = league_pyramid.get_item_metadata(index);
	
	# Remove it from league pyramid item list
	league_pyramid.remove_item(index)
	
	#Remove it from gamemap
	game_map.erase_tournament_by_id(tour.ID)
	
	#update_tournament_selection_popup();

func _on_add_tournament_pressed() -> void:
	if curr_nation == null:
		return
	
	# Create a new Tournament for the league
	var new_tour: Tournament = Tournament.new();
	new_tour.Name = "New Tournament"
	
	# Add it to the league pyramid
	var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
	var index = tournament_list.add_item("New Tournament", default_icon, true);
	tournament_list.set_item_metadata(index, new_tour);
	
	# Save to GameMap
	game_map.add_tournament(new_tour)
	
	# Save it to the terr/confed selected
	var sink = curr_nation
	if sink is Territory:
		sink.Tournaments.push_back(new_tour.ID)
	elif sink is Confederation:
		sink.Confed_Tournaments.push_back(new_tour.ID)
		
	#update_tournament_selection_popup();

func _on_delete_tournament_pressed():
	# Get index of selected item
	var selected_index_list = tournament_list.get_selected_items();
	var index: int;
	# If none are selected, return early
	if selected_index_list.is_empty():
		return
	else:
		index = selected_index_list[0];
		
	# Get Tournament
	var tour: Tournament = tournament_list.get_item_metadata(index)
	
	# Remove it from league pyramid item list
	tournament_list.remove_item(index)
	
	# Remove it from game_map
	game_map.erase_tournament_by_id(tour.ID)

	#update_tournament_selection_popup();

""" League Pyramid Editor Inputs Singals """
# League Logo Texture Button
func _on_league_logo_input_file_selected(path: String) -> void:
	# Check if valid, if not return
	if curr_league == null:
		return
	
	# Load Image of Territory Flag
	var logo: Image = Image.load_from_file(path);
	logo.resize(150, 150, 2);
	var logo_texture: ImageTexture = ImageTexture.create_from_image(logo);
	
	# Change Texture of Texture Button to reflect change
	get_node("../Territory League Pyramid/Tournament Edit Area/Header/TextureButton").texture_normal = logo_texture
	
	# Reflect changes on ItemList
	var selected_item: int = league_pyramid.get_selected_items()[0];
	league_pyramid.set_item_icon(selected_item, logo_texture);
	
	# Save Image into Territory Class
	logo.compress(Image.COMPRESS_BPTC);
	curr_league.Logo = logo;

# League Name LineEdit
func _on_league_name_text_changed(new_text: String) -> void:
	# Check if valid, if not return
	if curr_league == null:
		return
	
	#Store locally
	curr_league.Name = new_text;
	
	#Reflect changes on item_list
	var selected_item: int = league_pyramid.get_selected_items()[0];
	league_pyramid.set_item_text(selected_item, new_text);
	
# League Importance SpinBox
func _on_spin_box_value_changed(value: int) -> void:
	# Check if valid, if not return
	if curr_league == null:
		return
		
	curr_league.Importance = value;

# League Host Country LineEdit
func _on_host_country_input_text_changed(new_text: String) -> void:
	# Check if valid, if not return
	if curr_league == null:
		return
		
	curr_league.Host_Country_Name = new_text;
	
# League N Repeatition Years SpinBox
func _on_every_n_years_input_value_changed(value: float) -> void:
	# Check if valid, if not return
	if curr_league == null:
		return
		
	curr_league.Every_N_Years = value;

# League Start Date Month Selected
func _on_start_month_input_item_selected(index: int) -> void:
	# Check if valid, if not return
	if curr_league == null:
		return
		
	# First we get the selected month
	var month: String = get_node("../Territory League Pyramid/Tournament Edit Area/DatesInput/StartMonthInput").get_item_text(index);
	month = month.to_upper()
	
	# Get day input to edit later 
	var day_input: OptionButton = get_node("../Territory League Pyramid/Tournament Edit Area/DatesInput/StartDayInput");
	day_input.clear()
	
	# Put in correct days options for month into StartDayInput
	for day: int in range(1, DAYS[month] + 1):
		day_input.add_item(str(day));
		
		
	# Store month in League
	var month_num: int;
	var curr_index: int = 1
	for curr_month: String in DAYS.keys():
		if curr_month == month:
			month_num = curr_index
		else:
			curr_index += 1
	curr_league.Start_Date.push_back(month_num);

# League End Date Month Selected
func _on_end_month_input_item_selected(index: int) -> void:
	# Check if valid, if not return
	if curr_league == null:
		return
		
	# First we get the selected month
	var month: String = get_node("../Territory League Pyramid/Tournament Edit Area/DatesInput/EndMonthInput").get_item_text(index);
	month = month.to_upper()
	
	# Get day input to edit later 
	var day_input: OptionButton = get_node("../Territory League Pyramid/Tournament Edit Area/DatesInput/EndDayInput");
	day_input.clear()
	
	# Put in correct days options for month into StartDayInput
	for day: int in range(1, DAYS[month] + 1):
		day_input.add_item(str(day));
		
	# Store month in League
	var month_num: int;
	var curr_index: int = 1
	for curr_month: String in DAYS.keys():
		if curr_month == month:
			month_num = curr_index
		else:
			curr_index += 1
	curr_league.End_Date.push_back(month_num);

# League Start Date Day Selected
func _on_start_day_input_item_selected(index: int) -> void:
	# Check if valid, if not return
	if curr_league == null:
		return
		
	# First we get the selected month
	var day: String = get_node("../Territory League Pyramid/Tournament Edit Area/DatesInput/StartDayInput").get_item_text(index);
	var day_num: int = int(day)
	
	# Now we store 
	curr_league.Start_Date.push_back(day_num);

# League End Date Day Selected
func _on_end_day_input_item_selected(index: int) -> void:
	# Check if valid, if not return
	if curr_league == null:
		return
		
	# First we get day
	var day: String = get_node("../Territory League Pyramid/Tournament Edit Area/DatesInput/EndDayInput").get_item_text(index);
	var day_num: int = int(day);
	
	# Now we store
	curr_league.End_Date.push_back(day_num);


""" Tournament List Editor Inputs Signals """
# Tournament Logo Texture BUtton Pressed
func _on_texture_button_pressed() -> void:
	get_node("../../../../TournamentLogoInput").visible = true;

# Tournament Logo File Selected
func _on_tournament_logo_input_file_selected(path: String) -> void:
	# Check if valid, if not return
	if curr_tournament == null:
		return
	
	# Load Image of Territory Flag
	var logo: Image = Image.load_from_file(path);
	logo.resize(150, 150, 2);
	var logo_texture: ImageTexture = ImageTexture.create_from_image(logo);
	
	# Change Texture of Texture Button to reflect change
	get_node("../Territory Tournaments/Tournament Edit Area/Header/TournamentLogo").texture_normal = logo_texture
	
	# Reflect changes on ItemList
	var selected_item: int = tournament_list.get_selected_items()[0];
	tournament_list.set_item_icon(selected_item, logo_texture)
	
	# Save Image into Territory Class
	logo.compress(Image.COMPRESS_BPTC);
	curr_tournament.Logo = logo;

# Tournament Name LineEdit
func _on_tournament_name_text_changed(new_text: String) -> void:
	# Check if valid, if not return
	if curr_tournament == null:
		return
	
	curr_tournament.Name = new_text;
	
	# Reflect changes on ItemList
	var selected_item: int = tournament_list.get_selected_items()[0];
	tournament_list.set_item_text(selected_item, new_text);

# Tournament Importance Spinbox
func _on_tour_importance_input_value_changed(value: int) -> void:
	# Check if valid, if not return
	if curr_tournament == null:
		return
		
	curr_tournament.Importance = value;

# Tournament Host Country LineEdit
func _on_tour_host_country_input_text_changed(new_text: String) -> void:
	# Check if valid, if not return
	if curr_tournament == null:
		return
		
	curr_tournament.Host_Country_Name = new_text;

# Tournament Every N Years SpinBox
func _on_tour_every_n_years_input_value_changed(value: int) -> void:
	# Check if valid, if not return
	if curr_tournament == null:
		return
		
	curr_tournament.Every_N_Years = value;

# Tournament Start Date Month Input
func _on_tour_start_month_input_item_selected(index: int) -> void:
	# Check if valid, if not return
	if curr_tournament == null:
		return
		
	# First we get the selected month
	var month: String = get_node("../Territory Tournaments/Tournament Edit Area/DatesInput/TourStartMonthInput").get_item_text(index);
	month = month.to_upper()
	
	# Get day input to edit later 
	var day_input: OptionButton = get_node("../Territory Tournaments/Tournament Edit Area/DatesInput/TourStartDayInput");
	day_input.clear()
	
	# Put in correct days options for month into StartDayInput
	for day: int in range(1, DAYS[month] + 1):
		day_input.add_item(str(day));
		
		
	# Store month in League
	var month_num: int;
	var curr_index: int = 1
	for curr_month: String in DAYS.keys():
		if curr_month == month:
			month_num = curr_index
		else:
			curr_index += 1
	curr_tournament.Start_Date.push_back(month_num);

# Tournament Start Date Day Input
func _on_tour_start_day_input_item_selected(index: int) -> void:
	# Check if valid, if not return
	if curr_tournament == null:
		return
		
	# First we get the selected month
	var day: String = get_node("../Territory Tournaments/Tournament Edit Area/DatesInput/TourStartDayInput").get_item_text(index);
	var day_num: int = int(day)
	
	# Now we store 
	curr_tournament.Start_Date.push_back(day_num);

# Tournament End Data Month Input
func _on_tour_end_month_input_item_selected(index: int) -> void:
	# Check if valid, if not return
	if curr_tournament == null:
		return
		
	# First we get the selected month
	var month: String = get_node("../Territory Tournaments/Tournament Edit Area/DatesInput/TourEndMonthInput").get_item_text(index);
	month = month.to_upper()
	
	# Get day input to edit later 
	var day_input: OptionButton = get_node("../Territory Tournaments/Tournament Edit Area/DatesInput/TourEndDayInput");
	day_input.clear()
	
	# Put in correct days options for month into StartDayInput
	for day: int in range(1, DAYS[month] + 1):
		day_input.add_item(str(day));
		
	# Store month in League
	var month_num: int;
	var curr_index: int = 1
	for curr_month: String in DAYS.keys():
		if curr_month == month:
			month_num = curr_index
		else:
			curr_index += 1
	curr_tournament.End_Date.push_back(month_num);

# Tournament End Date Day Input
func _on_tour_end_day_input_item_selected(index: int) -> void:
	# Check if valid, if not return
	if curr_tournament == null:
		return
		
	# First we get day
	var day: String = get_node("../Territory Tournaments/Tournament Edit Area/DatesInput/TourEndDayInput").get_item_text(index);
	var day_num: int = int(day);
	
	# Now we store
	curr_tournament.End_Date.push_back(day_num);

# Make Domestic Cup Button Pressed
func _on_make_domestic_cup_pressed() -> void:
	# Save current selected tornament the domestic cup index
	var selected_index: int = tournament_list.get_selected_items()[0];
	if curr_nation is Territory:
		curr_nation.League_Cup = selected_index;
	elif curr_nation is Confederation:
		curr_nation.Cup = selected_index;
		
	# Now we reflect this in itemlist
	tournament_list.set_item_custom_bg_color(selected_index, DOMESTIC_CUP_COLOR)

# UnMake Domestic Cup Button Pressed
func _on_un_make_domestic_cup_pressed() -> void:
	# Save current selected tornament the domestic cup index
	var selected_index: int = tournament_list.get_selected_items()[0];
	if curr_nation is Territory:
		curr_nation.League_Cup = -1;
	elif curr_nation is Confederation:
		curr_nation.Cup = -1;
		
	# Now we reflect this in itemlist
	tournament_list.set_item_custom_bg_color(selected_index, DEFAULT_ITEMLIST_COLOR)

# Make Super Cup Pressed
func _on_make_super_cup_pressed() -> void:
	# Save current selected tornament the domestic cup index
	var selected_index: int = tournament_list.get_selected_items()[0];
	if curr_nation is Territory:
		curr_nation.Super_Cup = selected_index;
	elif curr_nation is Confederation:
		curr_nation.Super_Cup = selected_index;
		
	# Now we reflect this in itemlist
	tournament_list.set_item_custom_bg_color(selected_index, SUPER_CUP_COLOR);

# UnMake Super Cup Pressed
func _on_un_make_super_cup_pressed() -> void:
	# Save current selected tornament the domestic cup index
	var selected_index: int = tournament_list.get_selected_items()[0];
	if curr_nation is Territory:
		curr_nation.Super_Cup = -1;
	elif curr_nation is Confederation:
		curr_nation.Super_Cup = -1;
		
	# Now we reflect this in itemlist
	tournament_list.set_item_custom_bg_color(selected_index, DEFAULT_ITEMLIST_COLOR);


""" Functions below cover all things in League Editor """
# When Tournament Stage is Selected to be added
func _on_add_stage_popmenu_item_selected(index: int) -> void: 
	# Only makes sense to add nodes to league editor is a current tournament is selected to edit
	if tour_select.get_selected_id() == -1:
		return
	
	match index:
		0: 
			print("GroupStage Added")
			var new_node: GraphNode = groupstage_node.instantiate();
			add_child(new_node)
			new_node.size = NODE_SIZE;
		1:
			print("League Added")
			var new_node: GraphNode = league_node.instantiate();
			add_child(new_node)
			prepare_league_node(new_node);
			new_node.size = NODE_SIZE;
		2:
			print("KnockOut Added")
			var new_node: GraphNode = knockout_node.instantiate();
			add_child(new_node)
			new_node.size = NODE_SIZE;
		3:
			print("Single Knockout Added")
			var new_node: GraphNode = single_knockout_node.instantiate();
			add_child(new_node)
			new_node.size = NODE_SIZE;

func prepare_league_node(node: GraphNode) -> void:
	# First we need to connect the signal from inside to prepare eligable teams
	node.need_eligable_teams.connect(determine_eligable_teams);
	node.need_eligable_tours.connect(determine_eligable_tournaments);

""" Functions Below are For Getting Eligabe Teams """
func determine_eligable_teams(item_list: ItemList) -> void:
	if curr_nation == null:
		return

	var national_teams:Array[Team];
	
	if curr_nation is Territory:
		# If Territory, we need to get all teams in this territory, 
		# including Territories with this Territory as their CoTerritory
		national_teams = get_territory_national_teams(curr_nation);
	elif curr_nation is Confederation:
		# First we get the national teams in Confed and all Children Confeds
		national_teams = get_confed_national_teams(curr_nation);
		
	# Now we add National Teams to ItemList
	item_list.prepare_item_list(national_teams, "National Teams");
	
	# Now we need to add all club teams for each territory
	for national_team: Team in national_teams:
		var terr_id: int = national_team.Territory_ID;
		var club_teams: Array[Team] = get_territory_club_teams(terr_id);
		
		#Add it to itemlist
		item_list.prepare_item_list(club_teams, national_team.Territory_Name);

func get_confed_national_teams(confed: Confederation) -> Array[Team]:
	var queue: Array = [confed];
	var curr_confed: Confederation;
	var national_teams: Array[Team];
	
	
	while not queue.is_empty():
		# Get Current Confederations
		curr_confed = queue.pop_front();
		
		# For Curr_Confed, get the national teams
		for terr_id: int in curr_confed.Territory_List:
			var terr: Territory = game_map.get_territory_by_id(terr_id);
			if terr.National_Team not in national_teams:
				national_teams.push_back(terr.National_Team);

		#Now, we get the children and add them to queue
		var children: Array = curr_confed.Children_ID;
		
		for child: int in children:
			var child_confed: Confederation = game_map.get_confed_by_id(child)
			queue.push_back(child_confed);
		
		
	return national_teams;

func get_territory_national_teams(terr: Territory) -> Array[Team]:
	# For a specific territory, only the country and other country that have this country as 
	# CoTerritory will be selected
	var national_teams: Array[Team]
	national_teams.push_back(terr.National_Team);
	
	for t: Territory in game_map.Territories:
		if t.CoTerritory_ID == terr.Territory_ID:
			national_teams.push_back(t.National_Team);
				
				
	return national_teams

func get_territory_club_teams(terr_id: int) -> Array[Team]:
	# For a specific territory, only the country and other country that have this country as 
	# CoTerritory will be selected
	var club_teams: Array[Team] = [];
	
	var terr: Territory = game_map.get_territory_by_id(terr_id);
	for team_id: int in terr.Club_Teams_Rankings:
		var team: Team = game_map.get_team_by_id(team_id)
		club_teams.push_back(team);
	
	return club_teams


""" Function Below are for Getting Eligable Tournaments """
func determine_eligable_tournaments(option: OptionButton) -> void:
	if curr_nation == null:
		return
		
	if curr_nation is Confederation:
		get_confed_tournaments(curr_nation, option);

	pass
	
func get_confed_tournaments(confed: Confederation, option: OptionButton) -> void:
	# We will need to iterate through this confederation and all children confeds
	var queue: Array[Confederation] = [confed];
	var curr_confed: Confederation;
	var confed_collection: Array;
	var visited_terrs: Array;
	
	while not queue.is_empty():
		# Get Current Confederations
		curr_confed = queue.pop_front();
		confed_collection.push_back(curr_confed)
		
		# For Curr_Confed, go through all territories and add their tournaments to option
		for terr_id: int in curr_confed.Territory_List:
			# Get territory
			var terr: Territory = game_map.get_territory_by_id(terr_id);
			
			# In order to not repeat Territories
			if terr.Territory_ID in visited_terrs:
				continue
				
			# Get Tournaments
			var leagues: Array[int] = terr.Leagues;
			var tournaments: Array[int] = terr.Tournaments;
				
			# Merge to do both leagues and tournaments in one go
			leagues.append_array(tournaments);
			
			var tournaments_d: Array[Tournament] = [];
			for tour_id: int in leagues:
				var tour: Tournament = game_map.get_tournament_by_id(tour_id)
				tournaments_d.push_back(tour) 
			
			# Add Territory Tournaments to Options Button
			option.prepare_tour_select(tournaments_d, terr.Territory_Name);
				
			# Add Territory to visited
			visited_terrs.push_back(terr.Territory_ID);
		#Now, we get the children and add them to queue
		var children: Array = curr_confed.Children_ID;
		
		for child: int in children:
			var child_confed: Confederation =game_map.get_confed_by_id(child)
			queue.push_back(child_confed);
		
	
	
	# Once we reach here, we are done with territory tournaments, now we need confed tournaments
	for confed_iter: Confederation in confed_collection:
		var leagues: Array[int] = confed_iter.Confed_Leagues;
		var tournaments: Array[int] = confed_iter.Confed_Tournaments;
		
		# Merge to do both leagues and tournaments in one go
		leagues.append_array(tournaments)
		
		var tournaments_d: Array[Tournament] = [];
		for tour_id: int in leagues:
			var tour: Tournament = game_map.get_tournament_by_id(tour_id)
			tournaments_d.push_back(tour) 
		
		# Add Territory Tournaments to Options Button
		option.prepare_tour_select(tournaments_d, confed_iter.Name);
		
func get_territory_tournaments(terr: Territory, option: OptionButton) -> void:
	# For a specific territory, only the country and other country that have this country as 
	# CoTerritory will be selected
	var national_tours: Array[Tournament]
	
	# Add Terr Tournaments
	for tour_id: int in terr.Tournaments:
		var tour: Tournament = game_map.get_tournament_by_id(tour_id)
		national_tours.push_back(tour)
		
	#Add Terr League
	for tour_id: int in terr.Leagues:
		var tour: Tournament = game_map.get_tournament_by_id(tour_id)
		national_tours.push_back(tour)
	option.prepare_tour_select(national_tours, terr.Territory_Name);	
	
	
	national_tours.clear();
	# Add CoTerritory Tournaments
	for t: Territory in game_map.Territories:
		if t.CoTerritory_ID == terr.Territory_ID:
			for tour_id: int in t.Tournaments:
				var tour: Tournament = game_map.get_tournament_by_id(tour_id)
				national_tours.push_back(tour)
			for tour_id: int in t.Leagues:
				var tour: Tournament = game_map.get_tournament_by_id(tour_id)
				national_tours.push_back(tour)
			
			option.prepare_tour_select(national_tours, t.Territory_Name);
			national_tours.clear();
				
				
# User changed Starting Year
func _on_year_selection_value_changed(value: int) -> void:
	game_map.Starting_Year = value;
