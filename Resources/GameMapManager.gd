class_name GameMapManager extends Resource

""" Constants """
## This is the folder where territory images will be held. Save and load territory flags from this folder
const flag_folder: String = "user://Images/Territory Flags/";

## This is the folder where Team Logos will be stored. Save and load Team Logos from this folder
const logo_folder: String = "user://Images/Team Logos/";

## This is the folder where all GameMap files will be saved. Save and Load GameMaps from this folder
const game_map_folder: String = "user://save_files/"





## This function simply takes in a GameMap Resource and saves it.
## Images inside are compressed and the entire file is compressed too.
func save_game_map(game_map: GameMap, filename: String) -> void:
	# Given a game_map, we need to zip
	var save_path: String = game_map_folder + str(filename) + ".res";
	ResourceSaver.save(game_map, save_path, 32);


## This function loads the specific filename given. If error occurs, returns null;
func load_game_map(filename: String) -> GameMap:
	# Load the GameMap from the User Folder
	var load_path: String = game_map_folder + str(filename) + ".res";
	var game_map: GameMap = load(load_path) as GameMap;

	# Return GameMap
	return game_map;

## This functions goes through all team logos and ensures the path for the images follows the natural order. This is to ensure there are not huge gaps
## in the flag unique id. Doing this regularly helps to ensure the user can store up to 9223372036854775807 team logos (depending on their storage)
func organize_team_images() -> void:
	# First we need to access the folder that holds the Territoy Flags
	var logo_path: String = logo_folder
	var logo_folder_access: DirAccess = DirAccess.open(logo_path);
	
	# Now we need to ensure all natural numbers (starting from 1) are in the territory flag folder
	var logo_id: int = 1;
	for old_file_path: String in logo_folder_access.get_files():
		var new_file_path: String = logo_folder + str(logo_id) + ".png";
		if old_file_path != new_file_path:
			# Doesn't follow natural order, so make it follow it by swapping it for new file path
			# Get team with path
			# First we need to get all the save files.
			var save_file_folder: DirAccess = DirAccess.open(game_map_folder);
			var game_map_list: PackedStringArray = save_file_folder.get_files();
			
			# Now we need to go through all gamemaps 
			for game_map_path: String in game_map_list:
				var game_map: GameMap = load_game_map(game_map_path);
				
				# Now we need to iter through the curr game_map and see if we find a team with the given path
				for team: Team in game_map.Teams:
					if team.Logo_Path == old_file_path:
						team.Logo_Path = new_file_path;
						logo_folder_access.rename(old_file_path, new_file_path);
						save_game_map(game_map, game_map.Filename);
				
		logo_id += 1;
		

## This functions goes through all territory flags and ensures the path for the images follows the natural order. This is to ensure there are not huge gaps
## in the flag unique id. Doing this regularly helps to ensure the user can store up to 9223372036854775807 territory flags (depending on their storage)
func organize_territory_images() -> void:
	# First we need to access the folder that holds the Team Logos
	var flag_path: String = flag_folder
	var flag_folder_access: DirAccess = DirAccess.open(flag_path);
	
	# Now we need to ensure all natural numbers (starting from 1) are in the territory flag folder
	var flag_id: int = 1;
	for old_file_path: String in flag_folder_access.get_files():
		var new_file_path: String = flag_path + str(flag_id) + ".png";
		if old_file_path != new_file_path:
			# Doesn't follow natural order, so make it follow it by swapping it for new file path
			# Get team with path
			
			# First we need to get all the save files.
			var save_file_folder: DirAccess = DirAccess.open(game_map_folder);
			var game_map_list: PackedStringArray = save_file_folder.get_files();
			
			# Now we need to go through all gamemaps 
			for game_map_path: String in game_map_list:
				var game_map: GameMap = load_game_map(game_map_path);
				
				# Now we need to iter through the curr game_map and see if we find a team with the given path
				for terr: Territory in game_map.Territories:
					if terr.Flag_Path == old_file_path:
						terr.Flag_Path = new_file_path;
						flag_folder_access.rename(old_file_path, new_file_path);
						save_game_map(game_map, game_map.Filename);
		flag_id += 1;

