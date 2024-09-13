extends PopupPanel

""" Members """
var Choosen_Team: Team;


""" Constants """
enum Qualification_Type {INPUT = 0, SPECIFIC = 1, TOURNAMENT = 2, RANKING = 3};


""" ItemList """
# Local ItemList
@onready var item_list: ItemList = get_node("VBoxContainer/GridContainer/TeamsList");

# Global ItemList
@onready var global_item_list: ItemList = get_node("../TeamListArea/TeamList");

""" Function Signal Handlers"""
# When User Selects Team in ItemList
func _on_teams_list_item_selected(index: int) -> void:
	# We first need to get the underlying team
	var team: Team = item_list.get_item_metadata(index);
	
	# Set Choosen Team as That
	Choosen_Team = team;

# When User Clicks the Done Button
func _on_done_button_pressed():
	if Choosen_Team == null:
		return
	# First we need to save the Team to itemlist
	var team_name: String = Choosen_Team.Name;
	var logo: Image = Choosen_Team.Logo;
	var texture: Texture2D
	if logo != null:
		logo.decompress();
		texture = ImageTexture.create_from_image(logo);
	else:
		var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
		texture= default_icon;
	# Add to item list
	var index: int = global_item_list.add_item(team_name, texture, true);
	
	
	# We now need to make a new qualification system in order to set it as metadata
	var qual_info: QualificationSystem = QualificationSystem.new();
	qual_info.Qualification_Type = Qualification_Type.SPECIFIC;
	qual_info.Specific_Team = Choosen_Team.ID;
	
	#Add Metadata
	global_item_list.set_item_metadata(index, qual_info);
	
	
	# Make PopUp Panel Invisible
	get_node(".").visible = false;
