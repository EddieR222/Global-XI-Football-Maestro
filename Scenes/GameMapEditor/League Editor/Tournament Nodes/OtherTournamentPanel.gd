extends PopupPanel


""" Members """
var winner: bool;
var tournament_selected: Tournament;
var stage_id: TournamentStage;


""" Option Buttons """
@onready var tour_select_option: OptionButton = get_node("VBoxContainer/GridContainer/TournamentSelection");

@onready var stage_select_option: OptionButton = get_node("VBoxContainer/GridContainer/StageSelection");


""" Function Signal Handlers """
func _on_winners_input_toggled(toggled_on: bool) -> void:
	winner = toggled_on;
	return

# When the User Selects (aka clicks) on a tournemtn in the option button
func _on_tournament_selection_item_selected(index: int) -> void:
	pass
	
# For when the user clicks the Done Button
func _on_done_button_pressed():
	pass # Replace with function body.
