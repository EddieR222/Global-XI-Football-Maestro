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
func load_game_map(path: String) -> GameMap:
	# Load the GameMap from the User Folder
	var game_map: GameMap = load(path) as GameMap;

	# Return GameMap
	return game_map;
	
func load_game_map_with_filename(filename: String) -> GameMap:
	# Create Path Name
	var load_path: String = "user://save_files/{filename}.res".format({"filename": filename})
	var game_map: GameMap = load(load_path) as GameMap;
	
	return game_map

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











# Function to read a CSV file and return its contents as an array of dictionaries
func read_csv_file(file_path: String) -> Array:
	var data = []
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if file:
		var headers = []
		if not file.eof_reached():
			headers = file.get_csv_line()
		while not file.eof_reached():
			var line = file.get_csv_line()
			if line.size() == headers.size():
				var entry = {}
				for i in range(headers.size()):
					entry[headers[i].strip_edges()] = line[i]
				data.append(entry)
		file.close()
	else:
		print("Failed to open file: ", file_path)
	
	return data


func convert_to_territory_array(input_array: Array) -> Array[Territory]:
	var territory_array: Array[Territory] = []
	for element in input_array:
		if element is Territory:
			territory_array.append(element)
	return territory_array
func convert_to_confed_array(input_array: Array) -> Array[Confederation]:
	var territory_array: Array[Confederation] = []
	for element in input_array:
		if element is Confederation:
			territory_array.append(element)
	return territory_array
	
func convert_to_string_array(input_array: Array) -> Array[String]:
	var territory_array: Array[String] = []
	for element in input_array:
		if element is String:
			territory_array.append(element)
	return territory_array
	
# Example usage
func get_csv_data() -> GameMap:
	var gm: GameMap = GameMap.new();
	var csv_file_path = "res://Leagues around the world - Team Rating Calculations (1).csv" 
	var csv_data = read_csv_file(csv_file_path)
	#
	##First we have to Load the Teams
	#for entry in csv_data:
		#var team: Team = Team.new();
		#team.Name = entry["Team_Name"]
		#team.ID = entry["Team_ID"].to_int();
		#team.Rating = entry["Final Overall Rating"];
		#gm.add_team(team);
		
	# Second , we have to load the territories
	csv_file_path = "res://Game Directories - All Territories.csv"
	csv_data = read_csv_file(csv_file_path)
	for entry in csv_data:
		
		
		
		var terr: Territory = Territory.new();
		terr.Name = entry["Territory_Name"].strip_edges();

		
		# Load Flag for Territory
		var path: String = "user://Images/Territory Flags/"
		var img: Image = Image.load_from_file(path + terr.Name + ".png");
		terr.save_image_for_terr(img)
		
		terr.Code = entry["Code"];
		terr.Population = entry["Population"].to_float() 
		terr.Area = entry["Area"].to_float() 
		terr.GDP = entry["GDP"].to_float()
		terr.First_Names = convert_to_string_array(entry["First_Names"].split(",", false))
		terr.Last_Names = convert_to_string_array(entry["Last_Names"].split(",", false))
		terr.Rating = entry["Rating"].to_int();
		terr.League_Elo = entry["League_Elo"].to_float();
		gm.add_territory(terr);
		
	# Now we go through all the territories once added to add in coterritories
	for entry in csv_data:
		var terr_id: int = entry["ID"].to_int();
		var coterr_id: int = entry["CoTerritory_ID"].to_int();
		
		# Now lets get the territories
		var terr: Territory = gm.get_territory_by_id(terr_id)
		var coterr: Territory = gm.get_territory_by_id(coterr_id);
		
		# Finally we set it as the CoTerritory
		if coterr != null:
			terr.CoTerritory = coterr;
		
		
		
		
	csv_file_path = "res://Game Directories - All Confederations.csv"
	csv_data = read_csv_file(csv_file_path)
	for entry in csv_data:
		var confed: Confederation = Confederation.new();
		confed.Name = entry["Name"]
		confed.Level = entry["Level"].to_int();
		var terr_nums := Array(entry["Territory_List"].split(",", false));
		var terr_list:= terr_nums.map(func(num: String): return gm.get_territory_by_id(num.to_int()))
		confed.Territory_List = convert_to_territory_array(terr_list)
		
		gm.add_confederation(confed);
		
	for entry in csv_data:
		var confed_id: int = entry["ID"].to_int();
		
		# Get Corressponding Confed
		var confed: Confederation = gm.get_confed_by_id(confed_id);
		
		confed.Owner =  entry["Owner_ID"].to_int();
		
		# Get Children once All Confederations have been added already
		var confed_nums :=  Array(entry["Children_ID"].split(",", false));
		var confed_list : = confed_nums.map(func(num: String): return gm.get_confed_by_id(num.to_int()));
		confed.Children = convert_to_confed_array(confed_list);

		

	return gm 
	
	
func get_map_info() -> Dictionary:
	var csv_file_path = "res://Game Directories - All Territories.csv"
	var csv_data = read_csv_file(csv_file_path)
	var color_map: Dictionary;


	for entry in csv_data:
		var terr: Territory = Territory.new();
		terr.Name = entry["Territory_Name"].strip_edges();
		terr.Code = entry["Code"];
		terr.Population = entry["Population"].to_float() 
		terr.Area = entry["Area"].to_float() 
		terr.GDP = entry["GDP"].to_float()
		terr.Rating = entry["Rating"].to_int();
		terr.League_Elo = entry["League_Elo"].to_float();
		var color_nums = Array(entry["Color"].split(",")).map(func(num: String): return num.to_int());
		color_map[Vector3i(color_nums[0], color_nums[1], color_nums[2])] = terr;
		
		

		
	return color_map
