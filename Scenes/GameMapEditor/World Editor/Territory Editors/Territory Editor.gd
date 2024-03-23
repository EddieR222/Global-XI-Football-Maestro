extends GraphNode

#var territory: Territory;

@onready var territory: Territory = Territory.new();
@onready var game_map: GameMap;

"""
This function loads all the previous saved info of the country into the UI input fields. This is both useful for when loading a previous saved territory
or a previous edited territory
"""
func load_previous_territory_info(t: Territory) -> void:
	territory = t;
	get_tree().call_group("T_Info", "territory_selected", t);
	
	
	

"""
	All the functions below are signals that the input UI nodes send here to be saved in the variable Territory. 
"""
func _on_texture_button_pressed():
	$VBoxContainer2/HBoxContainer/FileDialog.visible = 1;

func _on_territory_name_edit_text_changed(new_text):
	# Apply name change
	territory.Territory_Name = new_text
	
	
func _on_CoT_ID_value_changed(value: float):
	territory.CoTerritory_ID = int(value);

func _on_co_t_name_text_changed(new_text: String):
	territory.CoTerritory_Name = new_text

func _on_code_name_text_text_changed(new_text: String):
	territory.Code = new_text	

func _on_pop_val_value_changed(value: float):
	territory.Population = value
	
func _on_area_val_value_changed(value: float):
	territory.Area = value
	
func _on_gdp_val_value_changed(value: float):
	territory.GDP = value

func _on_first_name_list_text_changed():
	var name_list: PackedStringArray = $"VBoxContainer2/GridContainer/First Name List".text.split(",", false, 0);
	name_list.sort();
	var saved_names: PackedStringArray = [];
	for name in name_list:
		saved_names.push_back(name.strip_edges(true, true));
	territory.First_Names = saved_names 
	
func _on_last_names_list_text_changed():
	var name_list: PackedStringArray = $"VBoxContainer2/GridContainer/Last Names List".text.split(",", false, 0);
	name_list.sort();
	var saved_names: PackedStringArray = [];
	for name in name_list:
		saved_names.push_back(name.strip_edges(true, true));
	territory.Last_Names = saved_names

func _on_rating_value_value_changed(value: float):
	territory.Rating = value;
	
func _on_league_rating_val_value_changed(value: float):
	territory.League_Elo = value;
	

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
	
	


