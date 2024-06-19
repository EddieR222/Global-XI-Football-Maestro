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
## Function to get confed by inputted id. Returns null if id is NOT valid. All IDS start at 1
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
## This functions sorts the confederations in alphabetical order by name. This creates a copy and returns the sorted array.
func sort_confederations(arr: Array[Confederation]) -> Array[Confederation]:
	# Create copy of arr
	var copy_arr: Array[Confederation] = arr.duplicate(true); 
	
	# Sort the array based on Name (Alphabetical Order)
	copy_arr.sort_custom(func(a: Confederation, b: Confederation): return a.Name.to_lower().strip_edges() < b.Name.to_lower().strip_edges());


	return copy_arr;

## This functions sorts the territories in alphabetical order by name. 
func sort_territories(arr: Array[Territory]) -> Array[Territory]:
	# Create copy of arr
	var copy_arr: Array[Territory] = arr.duplicate(true); 
	
	# Sort the array based on Name (Alphabetical Order)
	copy_arr.sort_custom(func(a: Territory, b: Territory): return a.Territory_Name.to_lower().strip_edges() < b.Territory_Name.to_lower().strip_edges());
	
	return copy_arr;

## This functions sorts the teams in alphabetical order by name. 
func sort_teams(arr: Array[Team]) -> Array[Team]:
	# Create copy of arr
	var copy_arr: Array[Team] = arr.duplicate(true); 
	
	# Sort the array based on Name (Alphabetical Order)
	copy_arr.sort_custom(func(a: Team, b: Team): return a.Name.to_lower().strip_edges() < b.Name.to_lower().strip_edges());
	
	return copy_arr

## This functions sorts the tournaments in alphabetical order by name. 
func sort_tournaments(arr: Array[Tournament]) -> Array[Tournament]:
	# Create copy of arr
	var copy_arr: Array[Tournament] = arr.duplicate(true); 
	
	# Sort the array based on Name (Alphabetical Order)
	copy_arr.sort_custom(func(a: Tournament, b: Tournament): return a.Name.to_lower().strip_edges() < b.Name.to_lower().strip_edges());
	
	return copy_arr

## This function sorts the Players by Name in alphabetical order by name.
func sort_players(arr: Array[Player]) -> Array[Player]:
	# Create copy of arr
	var copy_arr: Array[Player] = arr.duplicate(true); 
	
	# Sort the array based on Name (Alphabetical Order)
	copy_arr.sort_custom(func(a: Player, b: Player): return a.Name < b.Name)
	
	return copy_arr;

""" Adding a new member """
## Adds the given confederation to the list of confederation
## Automatically handles sorting and organizing ids
func add_confederation(confed: Confederation) -> void:
	if confed.Name == null:
		return
		
	# Add to array
	if (Confederations.is_empty()):
		confed.ID = 0;
	else:	
		var last_confed: Confederation = Confederations[Confederations.size() - 1];
		confed.ID = last_confed.ID + 1;
		
	Confederations.push_back(confed);
	

## Adds the given territory to the list of territories
## Automatically handles sorting and organizing ids
func add_territory(terr: Territory) -> void:
	if terr.Territory_Name == null:
		return
		
	# Add to array
	if (Territories.is_empty()):
		terr.Territory_ID = 0;
	else:	
		var last_terr: Territory = Territories[Territories.size() - 1];
		terr.Territory_ID = last_terr.Territory_ID + 1;
		
	Territories.push_back(terr);
	

## Adds the given team to the list of teams
## Automatically handles sorting and organizing ids
func add_team(team: Team) -> void:
	if team.Name == null:
		return
		
	# Add to array
	if (Teams.is_empty()):
		team.ID = 0;
	else:	
		var last_team: Team = Teams[Teams.size() - 1];
		team.ID = last_team.ID + 1;
		
	Teams.push_back(team);
	

## Adds the given tournament to the list of tournaments
## Automatically handles sorting and organizing ids
func add_tournament(tour: Tournament) -> void:
	if tour.Name == null:
		return
		
	# Add to array
	if (Tournaments.is_empty()):
		tour.ID = 0;
	else:	
		var last_tour: Tournament = Tournaments[Tournaments.size() - 1];
		tour.ID = last_tour.ID + 1;
		
	Tournaments.push_back(tour);
	

	
## Adds the given Player to the list of Players
## Automatically handles sorting and organizing ids
func add_player(player: Player) -> void:
	if player.Name == null:
		return
		
	# Add to array
	if (Players.is_empty()):
		player.ID = 0;
	else:	
		var last_player: Player = Players[Players.size() - 1];
		player.ID = last_player.ID + 1;
		
	Players.push_back(player);


""" Remove or Erase By ID """
## This functions erases the confederation by id (the confed id). 
## Array automatically will sort and organize id's after deletion
func erase_confederation_by_id(id: int) -> void:
	if id < 0 or id >= Confederations.size():
		return
		
	# Get index of id we want to remove
	var remove_index: int = Confederations.bsearch_custom(id, func(confed: Confederation): return confed.ID == id, true)
	
	
	
	# Now we ensure the remove_index is valid and that the value is the one we are looking for
	if (remove_index < 0 or remove_index >= Confederations.size()):
		return #remove_index is out of range so ignore
	
	if (Confederations[remove_index].ID == id):
		Confederations.remove_at(remove_index);
	
## This functions erases the territory by id (the territory id). 
## Array automatically will sort and organize id's after deletion
func erase_territories_by_id(id: int) -> void:
	if id < 0 or id >= Territories.size():
		return
		
	# Get index of id we want to remove
	var remove_index: int = Territories.bsearch_custom(id, func(terr: Territory): return terr.Territory_ID == id, true)
	
	
	
	# Now we ensure the remove_index is valid and that the value is the one we are looking for
	if (remove_index < 0 or remove_index >= Territories.size()):
		return #remove_index is out of range so ignore
	
	if (Territories[remove_index].Territory_ID == id):
		Territories.remove_at(remove_index);
	
## This functions erases the team by id (the team id). 
## Array automatically will sort and organize id's after deletion
func erase_team_by_id(id: int) -> void:
	if id < 0 or id >= Teams.size():
		return
		
	# Get index of id we want to remove
	var remove_index: int = Teams.bsearch_custom(id, func(team: Team): return team.ID == id, true)
	
	# Now we ensure the remove_index is valid and that the value is the one we are looking for
	if (remove_index < 0 or remove_index >= Teams.size()):
		return #remove_index is out of range so ignore
	if (Teams[remove_index].ID == id):
		Teams.remove_at(remove_index);
	
## This functions erases the tournament by id (the tournament id). 
## Array automatically will sort and organize id's after deletion
func erase_tournament_by_id(id: int) -> void:
	if id < 0 or id >= Tournaments.size():
		return
		
# Get index of id we want to remove
	var remove_index: int = Tournaments.bsearch_custom(id, func(tour: Tournament): return tour.ID == id, true)
	
	# Now we ensure the remove_index is valid and that the value is the one we are looking for
	if (remove_index < 0 or remove_index >= Tournaments.size()):
		return #remove_index is out of range so ignore
	
	if (Tournaments[remove_index].ID == id):
		Tournaments.remove_at(remove_index);

## This functions erases the player by id (the player id). 
## Array automatically will sort and organize id's after deletion
func erase_player_by_id(id: int) -> void:
	if id < 0 or id >= Players.size():
		return
	
	# Get index of id we want to remove
	var remove_index: int = Players.bsearch_custom(id, func(player: Player): return player.ID == id, true)
	
	# Now we ensure the remove_index is valid and that the value is the one we are looking for
	if (remove_index < 0 or remove_index >= Players.size()):
		return #remove_index is out of range so ignore
	
	if (Players[remove_index].ID == id):
		Players.remove_at(remove_index);

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




