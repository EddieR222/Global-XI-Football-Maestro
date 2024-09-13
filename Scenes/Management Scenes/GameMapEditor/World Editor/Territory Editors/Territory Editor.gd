extends GraphNode
## This Node is responcible for saving data for territory as the user inputs it
##
## This script has functions to save data correctly and ensure the World Map editor gets the correct data
##



## The local saved territory information
@onready var territory: Territory = Territory.new();

const COTERRITORY_INPUT: String = "VBoxContainer2/GridContainer/CoTerritory Input"

"""
This function loads all the previous saved info of the country into the UI input fields. This is both useful for when loading a previous saved territory
or a previous edited territory
"""
## This function is called when we open the Edit Territory Node or when a new territory is selected while the node is already visible
## This simply calls the function "territory_selected" for every UI element in the group T_Info
## This effecties loads the info saved for the passed in Territory
func load_previous_territory_info(t: Territory) -> void:
	# This function loads the OptionButton with current territory, this allows the user to easily reselect the CoTerritory of this territory if desired
	load_coterritory_popup(t);
	
	territory = t;
	get_tree().call_group("T_Info", "territory_selected", t);
	

	
## This function is called when Edit Territory is made visible or changes territory. This simply loads the OptionButton's Popup Menu with all 
## territories (except the one passed in) so these can be chosen to be the CoTerritory for the passed in Territory
func load_coterritory_popup(curr_terr: Territory) -> void:
	# First we need to get the popupmenu
	var input_node: OptionButton = get_node(COTERRITORY_INPUT);
	var popup: PopupMenu = input_node.get_popup();
	input_node.select(-1);
	
	# First we clear the option button and add a blank option 
	popup.clear();
	popup.add_theme_constant_override("icon_max_width", 25);
	popup.add_theme_font_size_override("font_size", 25)
	popup.add_item("None")
	
	
	# Now we need to add all the territories that the user has currently created
	for terr: Territory in GameMapManager.game_map.Territories:
		# In order to not allow a territory to be a CoTerritory of itself, we skip the passed in terr
		if terr.ID == curr_terr.ID:
			continue
	
		var flag: Image = terr.get_territory_image();
		var texture: Texture2D;
		if flag != null:
			texture = ImageTexture.create_from_image(flag);
		else:
			var default_icon: CompressedTexture2D = load("res://Images/icon.svg");
			texture = default_icon;
		popup.add_icon_item(texture, terr.Name);
		popup.set_item_metadata(-1, terr);
		
	popup.max_size = get_node("VBoxContainer2/HBoxContainer/MarginContainer/Territory Name Edit").size * 3


"""
All the functions below are signals that the input UI nodes send here to be saved in the variable Territory. 
"""
## This function is called when the user click the Texture Button, this will simply make the FileDialog visible for the user to pass in an image
func _on_texture_button_pressed() -> void:
	$VBoxContainer2/HBoxContainer/FileDialog.visible = 1;

## This is called when the user changes the name of the Territory in the Edit Territory Node
func _on_territory_name_edit_text_changed(new_text: String) -> void:
	# Apply name change
	territory.Name = new_text
	

## This is called when an territory is selected in the OptionButton for the CoTerritory and saves it
func _on_co_territory_input_item_selected(index: int) -> void:
	# Get the node
	var input: OptionButton = get_node("VBoxContainer2/GridContainer/CoTerritory Input")
	
	# Get territory saved in the option selected
	var terr: Territory = input.get_item_metadata(index);
	
	# Simply save it as the CoTerritory for the territory
	territory.CoTerritory = terr;


## This functions is called when the user changes the Code Name for the territory
func _on_code_name_text_text_changed(new_text: String) -> void:
	territory.Code = new_text	

## This value changes Population saved when the user changes it in the edit territory
func _on_pop_val_value_changed(value: float) -> void:
	territory.Population = value * 1_000_000;
	
## This function is called when the user changes the area value
func _on_area_val_value_changed(value: float) -> void:
	territory.Area = value * 1_000;

## This function is called when the user changes the GDP value	
func _on_gdp_val_value_changed(value: float) -> void:
	territory.GDP = value * 1_000_000

## This function is called when the user changes the First Name List
func _on_first_name_list_text_changed() -> void:
	## Gets Name Inputted
	var name_list: PackedStringArray = $"VBoxContainer2/GridContainer/First Name List".text.split(",", false, 0);
	name_list.sort();
	
	for index: int in range(name_list.size()):
		name_list[index] = name_list[index].strip_edges();
		
	territory.First_Names = Array(name_list);

## This function is called when the user changes the Last Name List
func _on_last_names_list_text_changed() -> void:
	var name_list: PackedStringArray = $"VBoxContainer2/GridContainer/Last Names List".text.split(",", false, 0);
	name_list.sort();
	
	for index: int in range(name_list.size()):
		name_list[index] = name_list[index].strip_edges();
		
	territory.Last_Names = Array(name_list);

## This function is called when the user changes the rating of the territory
func _on_rating_value_value_changed(value: float) -> void:
	territory.Rating = value;

## This function is called when the user changes the league elo of the territory
func _on_league_rating_val_value_changed(value: float):
	territory.League_Elo = value;
	
## This function is called when the user chooses an image and this saves it for the image of the territory
func _on_file_dialog_file_selected(path):
	# Load Image of Territory Flag
	var flag: Image = Image.load_from_file(path);
	flag.resize(120, 80, 2);
	
	var flag_texture: ImageTexture = ImageTexture.create_from_image(flag);
	
	# Change Texture of Texture Button to reflect change
	$VBoxContainer2/HBoxContainer/TextureButton.texture_normal = flag_texture

	#Now save to terr and image directory
	territory.save_image_for_terr(flag)
		
""" End of Signal Functions"""	
func get_territory() -> Territory:
	return territory;
	
	




