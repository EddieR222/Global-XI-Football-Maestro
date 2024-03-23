extends GraphNode

""" Tournament Stage """
@onready var stage: TournamentStage = TournamentStage.new();

""" Item List """
@onready var team_list: ItemList = get_node("TeamListArea/TeamList");


""" PopUp Menus """
# PopUpMenu for when player wants to add qualifying team, they need to select an option
@onready var add_team_button: MenuButton = get_node("TeamListArea/VBoxContainer/AddTeam");
@onready var add_team_popup: PopupMenu = add_team_button.get_popup();

# Panel for when Player Selects "Input Teams"
@onready var input_teams_panel: PopupPanel = get_node("InputTeamsPopPanel");
# Panel for when Player Selects "Specific Team"
@onready var specific_teams_panel: PopupPanel = get_node("SpecificTeamPopPanel");
# Panel for when Player Selects "Other Tournaments/Stage" 
@onready var other_tournament_panel: PopupPanel = get_node("OtherTournamentPanel");
# Panel for when Player Selects "Ranking"
@onready var ranking_panel: PopupPanel = get_node("RankingPanel");



""" Constants """
const NODE_SIZE: Vector2 = Vector2(600, 525);
var DAYS: Dictionary = {"JANUARY": 31, "FEBRUARY": 28, "MARCH": 31, "APRIL": 30, "MAY": 31, "JUNE":30, "JULY": 31, "AUGUST": 31, "SEPTEMBER": 30, "OCTOBER": 31, "NOVEMBER":30, "DECEMBER":31};


""" Custom Signals """
signal need_eligable_teams(item_list: ItemList);
signal need_eligable_tours(option_button: OptionButton);

func _ready():
	configure_popups();

""" Input Signals """
# Stage Name Changed
func _on_line_edit_text_changed(new_text: String) -> void:
	stage.Name = new_text;
	
# Updated Start Month
func _on_start_month_input_item_selected(index: int) -> void:		
	# First we get the selected month
	var month: String = get_node("DatesInput/StartMonthInput").get_item_text(index);
	month = month.to_upper()
	
	# Get day input to edit later 
	var day_input: OptionButton = get_node("DatesInput/StartDayInput");
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
	stage.Start_Date.push_back(month_num);

# Updated End Month 
func _on_end_month_input_item_selected(index: int) -> void:
	# First we get the selected month
	var month: String = get_node("DatesInput/EndMonthInput").get_item_text(index);
	month = month.to_upper()
	
	# Get day input to edit later 
	var day_input: OptionButton = get_node("DatesInput/EndDayInput");
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
	stage.End_Date.push_back(month_num);

# Updated Start Day
func _on_start_day_input_item_selected(index: int) -> void:
	# First we get the selected month
	var day: String = get_node("DatesInput/StartMonthInput").get_item_text(index);
	var day_num: int = int(day)
	
	# Now we store 
	stage.Start_Date.push_back(day_num);

# Updated End Day
func _on_end_day_input_item_selected(index: int) -> void:
	# First we get the selected month
	var day: String = get_node("DatesInput/EndMonthInput").get_item_text(index);
	var day_num: int = int(day)
	
	# Now we store 
	stage.End_Date.push_back(day_num);

# Updated Number of Games Per Team Played
func _on_num_games_per_team_input_value_changed(value: int) -> void:
	stage.set_num_matches_played(value)
	return

# Updated Points per Win
func _on_win_points_input_value_changed(value: int) -> void:
	stage.Points_For_Win = value;
	return

# Updated Points per Draw
func _on_draw_points_input_value_changed(value: int) -> void:
	stage.Points_For_Draw = value
	return

# Updated Points per Lose
func _on_lose_points_input_value_changed(value: int) -> void:
	stage.Points_For_Lose = value
	return



""" Adding and Deleting Teams on Qualifying List """
func _on_delete_team_pressed() -> void:
	pass # Replace with function body.
	
	
	
""" Configure Signals """
func configure_popups() -> void:
	# Connect Add Team PopUp to here
	add_team_popup.id_pressed.connect(_on_qualifying_method_selected);


func _on_qualifying_method_selected(index: int) -> void:
	match index:
		0: #Input Teams
			input_teams_panel.visible = true;
		1: #Specific Teams
			specific_teams_panel.visible = true;
			var item_list: ItemList = get_node("SpecificTeamPopPanel/VBoxContainer/GridContainer/TeamsList");
			emit_signal("need_eligable_teams", item_list);
		2: #Other Tournament/Stage
			other_tournament_panel.visible = true;
			var option: OptionButton = get_node("OtherTournamentPanel/VBoxContainer/GridContainer/TournamentSelection");
			emit_signal("need_eligable_tours", option);
		3: #Ranking
			ranking_panel.visible = true;
			

