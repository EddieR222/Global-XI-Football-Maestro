class_name GameMap extends Resource
## The File that contains all information for the game
##
## This Class contains all the information for the game including territories, confederations, teams, tournaments, etc.
## It also contains a lot of useful functions for parsing and working with this data

## The FileName Decided on in the World Editor
@export var Filename: String

@export_category("World Map")
## The Array that contains all Confederations. 
@export var Confederations: Array[Confederation] = [];

## The Array that contains all Territories. 
@export var Territories: Array[Territory] = [];

@export_category("Team Details")
## The Array that contains all Teams. 
@export var Teams: Array[Team] = [];

## The Array that contains all Stadiums. 
@export var Stadiums: Array[Stadium] = [];

@export_category("Tournament Details")
## The Array that contains all Tournaments.
@export var Tournaments: Array[Tournament] = [];

@export_category("Player Database")
## The Array that contains all Players
@export var Players: Array[Player] = [];

@export_category("Time Details")
## The starting date
@export var Start_Date: Array[int]

## The Year to Start
@export var Starting_Year: int = 2024; #current year is default

@export_category("Name Details")

## The Name Directory
@export var NameDirectory: Name_Directory = Name_Directory.new();

""" Getter Functions """
## Function to get confed by inputted id. Returns null if id is NOT valid
func get_confed_by_id(id: int) -> Confederation:
	# Check to see if id is valid, if not valid then return null
	if id < 0 or id >= Confederations.size():
		return null
	
	# If valid, then return corresponding confederation
	return Confederations[id];

## Function to get territory by inputted id. Returns null if id is NOT valid
func get_territory_by_id(id: int) -> Territory:
	# Check to see if id is valid, if not valid then return null
	if id < 0 or id >= Territories.size():
		return null
	
	# If valid, then return corresponding territory
	return Territories[id];

## Function to get team by inputted id. Returns null if id is NOT valid
func get_team_by_id(id: int) -> Team:
	# Check to see if id is valid, if not valid then return null
	if id < 0 or id >= Teams.size():
		return null
	
	# If valid, then return corresponding team
	return Teams[id];

## Function to get territory by inputted id. Returns null if id is NOT valid
func get_tournament_by_id(id: int) -> Tournament:
	# Check to see if id is valid, if not valid then return null
	if id < 0 or id >= Tournaments.size():
		return null
	
	# If valid, then return corresponding territory
	return Tournaments[id];

## Function to get player by inputted id. Returns null if id is NOT valid
func get_player_by_id(id: int) -> Player:
	# Check to see if id is valid, if not valid then return null
	if id < 0 or id >= Players.size():
		return null
	
	# If valid, then return corresponding territory
	return Players[id];
	
""" Sorting and ID managment """
## This functions sorts the confederations in alphabetical order by name. 
## Also changes IDs based on new alphabetical order
func sort_confederations() -> void:
	# Sort the array based on Name (Alphabetical Order)
	Confederations.sort_custom(func(a: Confederation, b: Confederation): return a.Name.to_lower().strip_edges() < b.Name.to_lower().strip_edges());
	
	# Now update the ID of each Confederation, based on index in Array
	var new_index = 0;
	for confed: Confederation in Confederations:
		# Get old index
		var old_index: int = confed.ID;
		
		# Swap it for new one
		# Convert OLD_ID to -100 (unused id)
		update_confederation_id(old_index, -100);
		# Now convert new_id to old_id
		update_confederation_id(new_index, old_index);
		# Finally, convert -100 to new_id
		update_confederation_id(-100, new_index);
		
		# Iter new_index
		new_index += 1;

## This functions sorts the territories in alphabetical order by name. 
## Also changes IDs based on new alphabetical order
func sort_territories() -> void:
	# Sort the array based on Name (Alphabetical Order)
	Territories.sort_custom(func(a: Territory, b: Territory): return a.Territory_Name.to_lower().strip_edges() < b.Territory_Name.to_lower().strip_edges());

	# Now update the ID of each Territory, based on index in Array
	var new_index = 0;
	for terr: Territory in Territories:
		# Get old index
		var old_index: int = terr.Territory_ID;
		
		# Swap it for new one
		# Convert OLD_ID to -100 (unused id)
		update_territory_id(old_index, -100);
		# Now convert new_id to old_id
		update_territory_id(new_index, old_index);
		# Finally, convert -100 to new_id
		update_territory_id(-100, new_index);
		
		# Iter new_index
		new_index += 1;
	
## This functions sorts the teams in alphabetical order by name. 
## Also changes IDs based on new alphabetical order
func sort_teams() -> void:
	
	# Sort the array based on Name (Alphabetical Order)
	Teams.sort_custom(func(a: Team, b: Team): return a.Name.to_lower().strip_edges() < b.Name.to_lower().strip_edges());
	
	## Now update the ID of each Territory, based on index in Array
	var new_index = 0;
	for team: Team in Teams:
		# Get old index
		var old_index: int = team.ID;
		
		# Skip if ID stayed the same
		if old_index == new_index:
			continue
		
		# Swap it for new one
		# Convert OLD_ID to -100 (unused id)
		update_team_id(old_index, -100);
		team.ID = -100;
		# Now convert new_id to old_id
		update_team_id(new_index, old_index);
		var team_to_switch: Array[Team] = Teams.filter(func(a: Team): return a.ID == new_index);
		if not team_to_switch.is_empty(): team_to_switch[0].ID = old_index
		# Finally, convert -100 to new_id
		update_team_id(-100, new_index);
		team.ID = new_index
		# Iter new_index
		new_index += 1;

## This functions sorts the tournaments in alphabetical order by name. 
## Also changes IDs based on new alphabetical order
func sort_tournaments() -> void:
	# Sort the array based on Name (Alphabetical Order)
	Tournaments.sort_custom(func(a: Tournament, b: Tournament): return a.Name.to_lower().strip_edges() < b.Name.to_lower().strip_edges());
	
	# Now update the ID of each Territory, based on index in Array
	var index = 0;
	for tour: Tournament in Tournaments:
		tour.ID = index;
		index += 1;

		
## This functions sorts the name directory in alphabetical order by name.
## Also changes the IDs based on new alphabetical order
func sort_names() -> void:
	# First we create a deep copy of the list of names
	var first_name_copy = NameDirectory.First_Names.duplicate(true);
	var last_name_copy = NameDirectory.Last_Names.duplicate(true);
	
	# Now we sort list of names
	NameDirectory.sort_names();
	
	# Now we iter through first names to update changed indexes
	for old_index in range(NameDirectory.First_Names.size()):
		# Get old name at old_index
		var name: String = first_name_copy[old_index];
		
		# Get new index of name
		var new_index: int = NameDirectory.get_id_of_name(name, true);
		
		# Skip if new index is same as before
		if old_index == new_index:
			continue
			
		# Else, we update the name id
		# Convert OLD_ID to -100 (unused id)
		update_name_id(old_index, -100);
		# Now convert new_id to old_id
		update_name_id(new_index, old_index);
		# Finally, convert -100 to new_id
		update_name_id(-100, new_index);
		
	# Now we iter through first names to update changed indexes
	for old_index in range(NameDirectory.Last_Names.size()):
		# Get old name at old_index
		var name: String = last_name_copy[old_index];
		
		# Get new index of name
		var new_index: int = NameDirectory.get_id_of_name(name, false);
		
		# Skip if new index is same as before
		if old_index == new_index:
			continue
			
		# Else, we update the name id
		# Convert OLD_ID to -100 (unused id)
		update_name_id(old_index, -100);
		# Now convert new_id to old_id
		update_name_id(new_index, old_index);
		# Finally, convert -100 to new_id
		update_name_id(-100, new_index);		
		
""" Adding a new member """
## Adds the given confederation to the list of confederation
## Automatically handles sorting and organizing ids
func add_confederation(confed: Confederation) -> void:
	if confed.Name == null:
		return
		
	# Add to array	
	confed.ID = Confederations.size();
	Confederations.push_back(confed);
	
	# Sort Confederations
	sort_confederations();

## Adds the given territory to the list of territories
## Automatically handles sorting and organizing ids
func add_territory(terr: Territory) -> void:
	if terr.Territory_Name == null:
		return
		
	# Add to array	
	terr.Territory_ID = Territories.size();
	Territories.push_back(terr);
	
	# Sort and organize id's
	sort_territories();

## Adds the given team to the list of teams
## Automatically handles sorting and organizing ids
func add_team(team: Team) -> void:
	if team.Name == null:
		return
		
	# Add to array	
	team.ID = Teams.size();
	Teams.push_back(team);
	
	# Sort and organize id's
	sort_teams();

## Adds the given tournament to the list of tournaments
## Automatically handles sorting and organizing ids
func add_tournament(tour: Tournament) -> void:
	if tour.Name == null:
		return
		
	# Add to array	
	tour.ID = Tournaments.size()
	Tournaments.push_back(tour);
	
	# Sort and organize id's
	sort_tournaments();
	
	
## Adds the given Player to the list of Players
## Automatically handles sorting and organizing ids
func add_player(player: Player) -> void:
	if player.Name == null:
		return
		
	# Add to array
	player.ID = Players.size();
	Players.push_back(player);
	
	# Sort Players and Organize IDs
	

	
""" Remove or Erase By ID """
## This functions erases the confederation by id (the confed id). 
## Array automatically will sort and organize id's after deletion
func erase_confederation_by_id(id: int) -> void:
	if id < 0 or id >= Confederations.size():
		return
		
	# Remove at index
	Confederations.remove_at(id);
	
	# Resort all territories
	sort_confederations();
	
## This functions erases the territory by id (the territory id). 
## Array automatically will sort and organize id's after deletion
func erase_territories_by_id(id: int) -> void:
	if id < 0 or id >= Territories.size():
		return
		
	# Remove at index
	Territories.remove_at(id);
	
	# Resort all territories
	sort_territories();
	
## This functions erases the team by id (the team id). 
## Array automatically will sort and organize id's after deletion
func erase_team_by_id(id: int) -> void:
	if id < 0 or id >= Teams.size():
		return
		
	# Remove at index
	Teams.remove_at(id);
	
	# Resort all territories
	sort_teams();
	
## This functions erases the tournament by id (the tournament id). 
## Array automatically will sort and organize id's after deletion
func erase_tournament_by_id(id: int) -> void:
	if id < 0 or id >= Tournaments.size():
		return
		
	# Remove at index
	Tournaments.remove_at(id);
	
	# Resort all territories
	sort_tournaments();
	
## This functions erases the player by id (the player id). 
## Array automatically will sort and organize id's after deletion
func erase_player_by_id(id: int) -> void:
	if id < 0 or id >= Players.size():
		return
		
	# Remove at index
	Players.remove_at(id);
	
	# Resort all territories
	#sort_tournaments();

""" Updating IDs Across GameMap """
## This function updates the old territory ID to the new one across the Entire GameMap
func update_territory_id(old_id: int, new_id: int) -> void:
	#First, we update the territory ID in all Territories
	for terr: Territory in Territories:
		if terr.Territory_ID == old_id:
			terr.Territory_ID = new_id;
			
		if terr.CoTerritory_ID == old_id:
			terr.CoTerritory_ID = new_id;

	# Second we update the territory IDs in all confederations
	for confed: Confederation in Confederations:
		confed.update_territory_id(old_id, new_id);

	# Third, we update all Territory Id's in Teams
	for team: Team in Teams:
		if team.Territory_ID == old_id:
			team.Territory_ID = new_id;

	# Fourth, we update all Territory Id's in Tournaments
	for tour: Tournament in Tournaments:
		if tour.Host_Country_ID == old_id:
			tour.Host_Country_ID = new_id;

## This function updates the old confed ID to the new one across the Entire GameMap
func update_confederation_id(old_id: int, new_id: int) -> void:
	# Thankfully, only need uopdating in Confederations themselves
	# We iter through All Confederations, and update Owner and Children ID 
	for confed: Confederation in Confederations:
		## Update Confederation ID itself if needed
		if confed.ID == old_id:
			confed.ID = new_id
		#
		# Update Children if old_id is present
		var index_to_change: int = confed.Children_ID.find(old_id);
		if index_to_change != -1:
			confed.Children_ID[index_to_change] = new_id
			
		# Update Owner ID if it is old_id
		if confed.Owner_ID == old_id:
			confed.Owner_ID = new_id;
		
## This function updates the old team ID to the new Team ID across the Entire GameMap
func update_team_id(old_id: int, new_id: int) -> void:
	# Get Largest Index of Territories or Confederations
	var largest_index: int =  Confederations.size() if Confederations.size() > Territories.size() else Territories.size();
	for index in range(largest_index):
		
		if index < Territories.size():
			var terr: Territory = Territories[index];
			# First, we check it against national_team
			if terr.National_Team == old_id:
				terr.National_Team = new_id; #swap id
			# Second, we check it if in club ranking
			var club_index: int = terr.Club_Teams_Rankings.find(old_id, 0);
			if club_index != -1:
				terr.Club_Teams_Rankings[club_index] = new_id; #swap id
				
			terr.Club_Teams_Rankings.sort();
		elif index >= Territories.size() and index >= Confederations.size():
			break
			
			
		if index < Confederations.size():
			var confed = Confederations[index]
			# First we check if team is in National Team Rankings
			var national_index: int = confed.National_Teams_Rankings.find(old_id, 0);
			if national_index != -1: #if not -1, then it is present in array
				confed.National_Teams_Rankings[national_index] = new_id; # swap id
			# Second, we check if team is in Club Team Rankings
			var club_index = confed.Club_Teams_Rankings.find(old_id, 0);
			if club_index != -1:
				confed.Club_Teams_Rankings[club_index] = new_id; # swap id
		elif index >= Territories.size() and index >= Confederations.size():
			break
	
func update_name_id(old_id: int, new_id: int) -> void:
	# We have to update the old_id to new_id. These are only present in Territories
	for terr: Territory in Territories:
		# First we check if old_id is in first names for terr
		var index: int = terr.First_Names.bsearch(old_id, true);
		if (terr.First_Names[index] == old_id):
			# If present, switch it
			terr.First_Names[index] = new_id;
			
		# Second, we check if old_id is in last names for terr
		index = terr.Last_Names.bsearch(old_id, true);
		if (terr.Last_Names[index] == old_id):
			#If present, switch it
			terr.Last_Names[index] = new_id;



""" Functions to Get Set of Teams """
## Get the Teams that are in the Tournament. Returns an empty array if error
func get_tournament_teams(tour_id: int) -> Array[Team]:
	# Verify ID
	if tour_id < 0 or tour_id >= Tournaments.size():
		return [];
		
	# Get the Tournament
	var tour: Tournament = get_tournament_by_id(tour_id);
	var teams_in_tour: Array[int] = tour.Teams;
	
	# Get Team for each Team ID
	var teams: Array[Team] = teams_in_tour.map(func(a: int): return get_team_by_id(a));
	
	return teams;

## Get the Teams that are in the Territory (not including the National Team). Returns an empty array if error
func get_territory_teams(terr_id: int) -> Array[Team]:
	#Verify ID
	if terr_id < 0 or terr_id >= Territories.size():
		return [];
		
	# Get Territory
	var terr: Territory = get_territory_by_id(terr_id);
	var club_list: Array[int] = terr.Club_Teams_Rankings;

	# Get Teams in Territory
	var club_teams: Array[Team] = club_list.map(func(a: int): return get_team_by_id(a));
	
	return club_teams;



""" Functions to Get Set of Players """

## Get the Players for the given team id. Returns an empty array if error
func get_team_roster(team_id: int) -> Array[Player]:
	# Get Team
	var team: Team = get_team_by_id(team_id);
	
	if team != null:
		var team_roster: Array[Player] = team.Players.map(func(a: int): return get_player_by_id(a));
		return team_roster
	
	return [];
	
## Get the Players for the given tournament id. Returns an empty array if error
func get_tournament_players(tour_id: int) -> Array[Player]:
	# Verify ID
	if tour_id < 0 or tour_id >= Tournaments.size():
		return []
		
	# Get the Teams
	var teams: Array[Team] = get_tournament_teams(tour_id);
	
	
	# Now get players in each team
	var player_roster: Array[Player] = [];
	if not teams.is_empty():
		for t: Team in teams:
			player_roster.append_array(get_team_roster(t.ID));
			
	return player_roster;
			
## Function to get all the player who are eligiable to play for the given Territory
func get_territory_pool(terr_id: int) -> Array[Player]:
	var territory_pool: Array[Player] = Players.filter(func(a: Player): return terr_id in a.Nationalities);
	
	return territory_pool;




