extends PopupPanel


""" Members """
var Num_Teams_Accept: int = 0;
enum Qualification_Type {INPUT = 0, SPECIFIC = 1, TOURNAMENT = 2, RANKING = 3};


""" Function to get Members """
func get_num_teams_accept() -> int:
	return Num_Teams_Accept;

func add_to_itemlist() -> void:
	# Get ItemList
	var item_list: ItemList = get_node("../TeamListArea/TeamList");
	
	# Add Correct Number of Teams to Accept
	for _i in range(Num_Teams_Accept):
		var index = item_list.add_item("Input Team", null, true);
		var qual_info : QualificationSystem = QualificationSystem.new();
		qual_info.Qualification_Type = Qualification_Type.INPUT;
		item_list.set_item_metadata(index, qual_info);
		
	
	pass

""" Signal Handlers """
# When Player Changes Number of Team to Accept from Input
func _on_num_teams_accept_input_value_changed(value: int) -> void:
	Num_Teams_Accept = value;
	return

# When Done Button is Pressed
func _on_done_button_pressed() -> void:
	# Add to Item List
	add_to_itemlist();
	
	# Clear
	visible = false;
