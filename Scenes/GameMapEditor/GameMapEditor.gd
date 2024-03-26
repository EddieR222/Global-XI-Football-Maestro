extends Control

""" Preloaded Scenes """
## The Packed Scene of World Editor
const WORLD_EDITOR_SCENE: PackedScene = preload("res://Scenes/GameMapEditor/World Editor/World Editor.tscn");

## The Packed Scene of Team Editor
const TEAM_EDITOR_SCENE: PackedScene = preload("res://Scenes/GameMapEditor/Team Editor/Team Editor.tscn");

## The Packed Scene of League Editor
const LEAGUE_EDITOR_SCENE: PackedScene = preload("res://Scenes/GameMapEditor/League Editor/League Editor.tscn");

## The Packed Scene of Player Editor
const PLAYER_EDITOR_SCENE: PackedScene = preload("res://Scenes/GameMapEditor/Player Editor/PlayerEditor.tscn");

""" Save Files Folder """
const save_file_folder: String = "user://save_files/"

""" GameMap Choosen or New """
@onready var Game_Map: GameMap = GameMap.new();
@onready var Game_Map_Manager: GameMapManager = GameMapManager.new();


""" Previous Path Used """
var File_Path: String = "";

""" LineEdit """
@onready var Line_Edit: LineEdit = get_node("TopBottom/MarginContainer/FileSelecter/LineEdit");


## When the File Button is pressed. This simply makes the File Dialog PopUp Visible
func _on_file_selection_pressed() -> void:
	get_node("FileDialog").visible = true;
	return

## This runs when the user selects a GameMap File to open. This function opens the file
func _on_file_dialog_file_selected(path: String) -> void:
	# Once Path is choosen, lets try to load it into the GameMap
	Game_Map = Game_Map_Manager.load_game_map(path)
	
	# Ensure GameMap was loaded correctly, if not then show user error
	File_Path = path
	if Game_Map == null:
		get_node("FileError").visible = true;
	
	# Here we know GameMap has loaded correctly so change FileName LineEdit to reflect change
	Line_Edit.text = File_Path.get_file().get_basename();
	
	# Now save GameMap to "SelectedFile" so the editors know which to save
	Game_Map_Manager.save_game_map(Game_Map, "selected_game_map");

## Runs when the user clicks the try again button. If it works then great otherwise they should try another
func _on_file_error_confirmed():
	# Once Path is choosen, lets try to load it into the GameMap
	Game_Map = Game_Map_Manager.load_game_map(File_Path)
	
	# Ensure GameMap was loaded correctly, if not then show user error
	if Game_Map == null:
		get_node("FileError").visible = true;
	
	# Here we know GameMap has loaded correctly
	Line_Edit.text = File_Path.get_file().get_basename();
	
	# Now save GameMap to "SelectedFile" so the editors know which to save
	Game_Map_Manager.save_game_map(Game_Map, "selected_game_map");
	
	
## When the user clicks "Try Another" and just makes the File Dialog Visible again so they can try another File
func _on_file_error_canceled():
	get_node("FileDialog").visible = true;
	return

## When the user clicks the World Editor Button, switches scene to World Editor
func _on_world_editor_button_pressed() -> void:
	# First Check if Game Map/File has been loaded
	if File_Path.is_empty():
		return
		
	# Now we instantiate the World Editor Scene
	get_tree().change_scene_to_packed(WORLD_EDITOR_SCENE);
		
## When the user clicks the Team Editor Button, switches scene to Team Editor
func _on_team_editor_button_pressed():
	# First Check if Game Map/File has been loaded
	if File_Path.is_empty():
		return
		
	# Now we instantiate the World Editor Scene
	get_tree().change_scene_to_packed(TEAM_EDITOR_SCENE);

## When the user clicks the Tournament Editor Button, switches scene to Tournament Editor
func _on_tournament_editor_button_pressed():
	# First Check if Game Map/File has been loaded
	if File_Path.is_empty():
		return
		
	# Now we instantiate the World Editor Scene
	get_tree().change_scene_to_packed(LEAGUE_EDITOR_SCENE);

## When the user clicks the Player Editor Button, switches scene to Player Editor
func _on_player_editor_button_pressed():
	# First Check if Game Map/File has been loaded
	if File_Path.is_empty():
		return
		
	# Now we instantiate the World Editor Scene
	get_tree().change_scene_to_packed(PLAYER_EDITOR_SCENE);

## When the user clicks the Stadium Editor Button, switches scene to Stadium Editor
func _on_stadium_editor_button_pressed():
	# First Check if Game Map/File has been loaded
	if File_Path.is_empty():
		return
		
	# Now we instantiate the World Editor Scene
	get_tree().change_scene_to_packed(WORLD_EDITOR_SCENE);

## When the user clicks the Manager Editor Button, switches scene to Manager Editor
func _on_manager_editor_button_pressed():
	# First Check if Game Map/File has been loaded
	if File_Path.is_empty():
		return
		
	# Now we instantiate the World Editor Scene
	get_tree().change_scene_to_packed(WORLD_EDITOR_SCENE);

## When the user clicks the Kit Editor Button, switches scene to Kit Editor
func _on_kit_editor_button_pressed():
	# First Check if Game Map/File has been loaded
	if File_Path.is_empty():
		return
		
	# Now we instantiate the World Editor Scene
	get_tree().change_scene_to_packed(WORLD_EDITOR_SCENE);

## When the user clicks the Trophy Editor Button, switches scene to Trophy Editor
func _on_trophy_editor_button_pressed():
	# First Check if Game Map/File has been loaded
	if File_Path.is_empty():
		return
		
	# Now we instantiate the World Editor Scene
	get_tree().change_scene_to_packed(WORLD_EDITOR_SCENE);


func _on_line_edit_text_changed(new_text):
	File_Path = "user://save_files/{filename}.res".format({"filename": new_text})

## Runs when User Clicks the "Save" Button. This simply saves the GameMap
func _on_save_button_pressed():
	# Create GameMapManager to save game later
	var game_map_manager: GameMapManager = GameMapManager.new();
	
	# Save Filename into GameMap
	Game_Map.Filename = File_Path.get_file().get_basename();
	
	# Save GameMap to save_files
	game_map_manager.save_game_map(Game_Map, File_Path.get_file().get_basename());
	
	
