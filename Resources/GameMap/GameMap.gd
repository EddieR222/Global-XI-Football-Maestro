class_name GameMap extends Resource
## The File that contains all information for the game
##
## This Class contains all the information for the game including territories, confederations, teams, tournaments, etc.
## It also contains a lot of useful functions for parsing and working with this data
## WARNING Please only use the provided functions to interact with the data stored in this class. This helps ensure correctness

## The FileName Decided on in the World Editor
@export var File_Name: String;

@export_category("World Map")
## The Array that contains all Confederations. 
@export var Confederations: Array[Confederation] = [];

## This is simply a pointer to the World Node, just so we can quickly reference it
@export var World_Confed: Confederation;

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
@export var Date: Array[int] # Format of 0 = Month 1 = Day 2 = Year


@export_category("Signals")
## This signal is emitted when the ID of a confederation is changed. This allows us to efficently change any weak pointers (int) that point to confederations
signal confed_id_changed;


## This signal is emitted when the ID of a Territory is changed. This allows us to efficently change any weak pointers (int) that point to Territory
signal terr_id_changed;


## This signal is emitted when the ID of a Team is changed. This allows us to efficently change any weak pointers (int) that point to Team
signal team_id_changed;

""" Getter Functions """
## Function to get confed by inputted id. Returns null if id is NOT valid.
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
## This functions sorts the confederations in alphabetical order by name. Corrects all IDs to new order
func sort_confederations() -> void:
	# Sort the array based on Name (Alphabetical Order)
	Confederations.sort_custom(func(a: Confederation, b: Confederation): return a.Name.to_lower() < b.Name.to_lower());

	# Now we reassign ID's based on new position in the Array
	for new_index in range(Confederations.size()):
		# Get the old ID of the confederation, should just be the ID
		var old_id: int = Confederations[new_index].ID
		# Now we quickly check if old_id is the same as new_index, in which case we can skip
		if old_id == new_index:
			continue
		
		## Now we manually change the ID 
		#Confederations[new_index].ID = new_index;
		
		# Now we emit that the confed id has changed for all resources have a number pointer to the confederation
		confed_id_changed.emit(old_id, -100);
		confed_id_changed.emit(new_index, old_id);
		confed_id_changed.emit(-100, new_index);
		
	# Log all Confederations and their new ID's
	LogDuck.d("Confederations after Sorting")
	for confed: Confederation in Confederations:
		# Log Territory
		LogDuck.d("[{id}]: [color=green]Name: {name} | Level: {level} | Owner: {owner}  ".format({"name": confed.Name, "id": confed.ID, "level": confed.Level, "owner":confed.Owner}))

## This functions sorts the territories in alphabetical order by name. Corrects all IDs to new order
func sort_territories() -> void:
	# Sort the array based on Name (Alphabetical Order)
	Territories.sort_custom(func(a: Territory, b: Territory): return a.Name.to_lower() < b.Name.to_lower());
	
	# Now we reassign ID's based on new position in the Array
	for new_index in range(Territories.size()):
		var old_id: int = Territories[new_index].ID
		Territories[new_index].ID = new_index;
		terr_id_changed.emit(old_id, -100)
		terr_id_changed.emit(new_index, old_id);
		terr_id_changed.emit(-100, new_index);
		
		
	# Log all Confederations and their new ID's
	LogDuck.d("Territories after Sorting")
	for terr: Territory in Territories:
		# Log Territory
		LogDuck.d("[{id}]: [color=green]Name: {name}  ".format({"name": terr.Name, "id": terr.ID}))

## This functions sorts the teams in alphabetical order by name. 
func sort_teams() -> void:
	# Sort the array based on Name (Alphabetical Order)
	Teams.sort_custom(func(a: Team, b: Team): return a.Name.to_lower() < b.Name.to_lower());
	
	# Now we reassign ID's based on new position in the Array
	for new_index in range(Teams.size()):
		var old_id: int = Teams[new_index].ID
		Teams[new_index].ID = new_index;
		team_id_changed.emit(old_id, -100)
		team_id_changed.emit(new_index, old_id);
		team_id_changed.emit(-100, new_index);

## This functions sorts the tournaments in alphabetical order by name. 
func sort_tournaments() -> void:
	# Sort the array based on Name (Alphabetical Order)
	Tournaments.sort_custom(func(a: Tournament, b: Tournament): return a.Name.to_lower() < b.Name.to_lower());
	
	# Now we reassign ID's based on new position in the Array
	for new_index in range(Tournaments.size()):
		Tournaments[new_index].ID = new_index;

## This function sorts the Players by Name in alphabetical order by name.
func sort_players() -> void:
	# Sort the array based on Name (Alphabetical Order)
	Players.sort_custom(func(a: Player, b: Player): return a.Name < b.Name);
	
	# Now we reassign ID's based on new position in the Array
	for new_index in range(Players.size()):
		Players[new_index].ID = new_index;

""" Adding a new member """
## Adds the given confederation to the list of confederation
## Automatically handles sorting and organizing ids (sorts alphabetically)
## Returns bool if Confederation was added successfully
func add_confederation(confed: Confederation) -> bool:
	if confed.Name.is_empty():
		LogDuck.w("Adding Confederation Failed: Name String was empty")
		return false;
	
	# Check if world confed
	if confed.Level == 0:
		World_Confed = confed;
	
	# Connect the Confederation to needed signals
	confed.connect_signal(confed_id_changed);
	confed.ID = -10
		
	# Add to array
	confed.Name.strip_edges();
	Confederations.push_back(confed);
	sort_confederations();
	
	# Log the Confederation
	LogDuck.d("Added new Confederation to GameMap \n\t[color=green]Name: {name} \n\tID: {id} \n\tLevel: {level} \n\tOwner: {owner}\n".format({"name": confed.Name, "id": confed.ID, "level": confed.Level, "owner":confed.Owner}))
		
	# Now we return True to show we successfully added confederation to GameMap
	return true

## Adds the given Array of Confederations to the list of confederation
## Automatically handles sorting and organizing ids (sorts alphabetically)
## Returns bool if Confederations were added successfully
func add_confederations(confeds: Array[Confederation]) -> bool:
	# Validate all have valid names
	for confed: Confederation in confeds:
		if confed.Name.is_empty():
			LogDuck.w("Adding Confederation Failed: Name String was empty")
			return false
		# Check if world confed
		if confed.Level == 0:
			World_Confed = confed;
		
	# Now we add to array and sort
	Confederations.append_array(confeds);
	sort_confederations();
	
	# Log all added Confederations
	for confed: Confederation in confeds:
		# Log the Confederation
		LogDuck.d("Added new Confederation to GameMap \n\t[color=green]Name: {name} \n\tID: {id} \n\tLevel: {level} \n\tOwner: {owner}\n".format({"name": confed.Name, "id": confed.ID, "level": confed.Level, "owner":confed.Owner}))
	
	# Now we return True to show we successfully added the confederations to GameMap
	return true

## Adds the given territory to the list of territories
## Automatically handles sorting and organizing ids
## Returns bool if Territory was added succesfully
func add_territory(terr: Territory) -> bool:
	if terr.Name.is_empty():
		LogDuck.w("Adding Territory Failed: Name String was empty")
		return false;
		
	# Add to array
	Territories.push_back(terr);
	sort_territories();
	
	# Log Territory
	LogDuck.d("Added new Territory to GameMap \n\t[color=green]Name: {name} \n\tID: {id}\n".format({"name": terr.Name, "id": terr.ID}))
	
	# Now we return True to show we successfully added confederation to GameMap
	return true

## Adds the given Array of Territories to the list of territories
## Automatically handles sorting and organizing ids
## Returns bool if Territories were added succesfully
func add_territories(terrs: Array[Territory]) -> bool:
	for terr in terrs:
		if terr.Name.is_empty():
			LogDuck.w("Adding Territory Failed: Name String was empty")
			return false;
		
	# Add to array
	Territories.append_array(terrs)
	sort_territories();
	
	# Log all added Territories
	for terr: Territory in terrs:
		# Log Territory
		LogDuck.d("Added new Territory to GameMap \n\t[color=green]Name: {name} \n\tID: {id}\n".format({"name": terr.Name, "id": terr.ID}))
	
	# Now we return True to show we successfully added territories to GameMap
	return true

## Adds the given team to the list of teams
## Automatically handles sorting and organizing ids
## Returns bool if Team was added succesfully
func add_team(team: Team) -> bool:
	if team.Name.is_empty():
		LogDuck.w("Adding Team Failed: Name String was empty")
		return false
		
	# Add to array
	Teams.push_back(team);
	sort_teams();
	
	# Log Added team
	LogDuck.d("Added new Team to GameMap \n\t[color=green]Name: {name} \n\tID: {id}\n".format({"name": team.Name, "id": team.ID}));
	
	
	# Now we return True to show we successfully added Team
	return true;

## Adds the given aeeay of teams to the list of teams
## Automatically handles sorting and organizing ids
## Returns bool if Teams were added succesfully
func add_teams(teams: Array[Team]) -> bool:
	for team in teams:
		if team.Name.is_empty():
			LogDuck.w("Adding Team Failed: Name String was empty")
			return false
		
	# Add to array
	Teams.append_array(teams);
	sort_teams();
	
	
	# Now we return True to show we successfully added Teams
	return true;

## Adds the given tournament to the list of tournaments
## Automatically handles sorting and organizing ids
## Returns bool if Tournament was added succesfully
func add_tournament(tour: Tournament) -> bool:
	if tour.Name.is_empty():
		LogDuck.w("Adding Tournament Failed: Name String was empty")
		return false

	# Add it to List and sort
	Tournaments.push_back(tour);
	sort_tournaments();

	# Now we return true to confirm we added successfully
	return true

## Adds the given Array of tournaments to the list of tournaments
## Automatically handles sorting and organizing ids
## Returns bool if Tournaments were added succesfully
func add_tournaments(tours: Array[Tournament]) -> bool:
	for tour in tours:
		if tour.Name.is_empty():
			LogDuck.w("Adding Tournament Failed: Name String was empty")
			return false
		
	# Add to array
	Tournaments.append_array(tours);
	sort_tournaments();
	
	# Now we return True to show we successfully added Teams
	return true;

## Adds the given Player to the list of Players
## Automatically handles sorting and organizing ids
## Returns bool if Player was added succesfully
func add_player(player: Player) -> bool:
	if player.Name.is_empty():
		LogDuck.w("Adding Player Failed: Name String was empty")
		return false
		
	# Add to array
	Players.push_back(player);
	sort_players();
	
	# Log Added Player
	LogDuck.d("Added new Player to GameMap \n\t[color=green]Name: {name} \n\tID: {id}\n".format({"name": player.Name, "id": player.ID}))
	
	# Now we return True to show we successfully added Teams
	return true;

## Adds the given Array of Players to the list of Players
## Automatically handles sorting and organizing ids
## Returns bool if Players were added succesfully
func add_players(ps: Array[Player]) -> bool:
	for player in ps:
		if player.Name.is_empty():
			LogDuck.w("Adding Player Failed: Name String was empty")
			return false;
			
	# Now we add them to Players
	Players.append_array(ps);
	sort_players();
	
	# Now we return true to confirm we added successfully
	return true;


""" Remove or Erase By ID """ #Have to expand
## This functions erases the confederation by id (the confed id). 
## Array automatically will sort and organize id's after deletion
## This returns a bool value to indicate if confederation was erased successfully
func erase_confederation_by_id(id: int) -> bool:
	if id < 0 or id >= Confederations.size():
		LogDuck.w("Erasing Confederation Failed: Passed in ID is invalid")
		return false
		
	# Log Confederation before deleting 
	var confed: Confederation = Confederations[id];
	LogDuck.d("Erasing Confederation from GameMap: [color=green]\n\tName: {name}\n\tID: {id}\n\tLevel: {level}\n\tOwner: {owner}".format({"name": confed.Name, "id": confed.ID, "level": confed.Level, "owner": confed.Owner}));
	var owner_confed: Confederation = get_confed_by_id(confed.Owner)
	var confed_children: Array[Confederation] = confed.Children;

	# Now we must also delete any references to this Confederation
	# We can do this by getting 1) Getting rid of Owner Pointers to this node via its Children
	for child: Confederation in confed_children:
		child.Owner = -1;
	# 2) We delete the pointers to this node for it's owner node (if any) to this node
	if owner_confed != null:
		owner_confed.Children.erase(confed)
		
	
	# Now we delete it now that all pointers to this confederation is 1 (then zero once we delete it)
	Confederations.remove_at(id);
	sort_confederations();
	
	
	# Now we return to confirm we removed confederation
	return true;

## This functions erases the confederation by reference to the reference itself 
## Array automatically will sort and organize id's after deletion
## This returns a bool value to indicate if confederation was erased successfully	
func erase_confederation(confed: Confederation) -> bool:
	var confed_deleted: bool = erase_confederation_by_id(confed.ID)
	
	# Now we return to confirm we removed confederation (even if not present we can be well assured it isn't present anymore)
	return confed_deleted;

## This functions erases the territory by id (the territory id). 
## Array automatically will sort and organize id's after deletion
## This returns a bool value to indicate if Territory was erased successfully	
func erase_territory_by_id(id: int) -> bool:
	if id < 0 or id >= Territories.size():
		return false;
		
	Territories.remove_at(id);
	sort_territories();
	
	# Now we return to confirm we removed territory
	return true;

## This functions erases the territory by reference to the territory itself
## Array automatically will sort and organize id's after deletion
## This returns a bool value to indicate if Territory was erased successfully	
func erase_territory(terr: Territory) -> bool:
	var terr_deleted: bool = erase_territory_by_id(terr.ID)
	
	# Now we return to confirm we removed territory
	return terr_deleted;

## This functions erases the team by id (the team id). 
## Array automatically will sort and organize id's after deletion
## This returns a bool value to indicate if Team was erased successfully	
func erase_team_by_id(id: int) -> bool:
	if id < 0 or id >= Teams.size():
		return false
		
		
	Teams.remove_at(id);
	sort_teams();
	
	#Now we return to confirm we removed the team
	return true;

## This functions erases the team by reference to the Team itself
## Array automatically will sort and organize id's after deletion
## This returns a bool value to indicate if Team was erased successfully	
func erase_team(team: Team) -> bool:
	Teams.erase(team);
	sort_teams();
	
	# Now we return to confirm we removed territory
	return true;

## This functions erases the tournament by id (the tournament id). 
## Array automatically will sort and organize id's after deletion
func erase_tournament_by_id(id: int) -> bool:
	if id < 0 or id >= Tournaments.size():
		return false

	# Erase and sort
	Tournaments.remove_at(id);
	sort_tournaments();
	
	# Now return true to confirm we erased the team
	return true

## This functions erases the player by id (the player id). 
## Array automatically will sort and organize id's after deletion
## This returns a bool value to indicate if Player was erased successfully	
func erase_player_by_id(id: int) -> bool:
	if id < 0 or id >= Players.size():
		return false;
		
	# Remove it
	Players.remove_at(id);
	sort_players();
	
	# Return true to confirm we deleted it
	return true;

## This functions erases the player by reference 
## Array automatically will sort and organize id's after deletion
## This returns a bool value to indicate if Player was erased successfully	
func erase_player(player: Player) -> bool:
	Players.erase(player);
	sort_players();

	# Now we return to confirm we removed Player
	return true;
		
		
""" Functions to return Confederations """
## This function will traverse the confederations until it finds the first instance of the territory id.[br]
## This will return an array of confed id for all confederations (level 1+) that contain the country. Left to right means increasing level
func get_confeds_of_territory(terr_id: int) -> Array[Confederation]:
	# First we need to start at the top of the confederation graph
	var queue: Array[Confederation] = [World_Confed];
	var path: Array[Confederation] = [];
	var curr_confed: Confederation;
	var terr: Territory = get_territory_by_id(terr_id);
	
	
	while not queue.is_empty():
		# Get the curr confed by popping from front
		curr_confed = queue.pop_front();
		
		# Now we check if current confed has children
		for child: Confederation in curr_confed.Children:
			# Now we only go to child if they have our desired territory in their territory list
			if terr in child.Territory_List:
				queue.append(child)
				path.append(child)
		
		
	return path;


func get_confeds_with_condition(c: Callable) -> Array[Confederation]:
	# First we need to start at the top of the confederation graph
	var queue: Array[Confederation] = [World_Confed];
	var path: Array[Confederation] = [World_Confed];
	var curr_confed: Confederation;
	
	while not queue.is_empty():
		# Get the curr confed by popping from front
		curr_confed = queue.pop_front();
		
		# Now we check if current confed has children
		for child: Confederation in curr_confed.Children:
			# Now we only go to child if they have our desired territory in their territory list
			if c.call():
				queue.append(child)
				path.append(child)
		
		
	return path;

""" Functions to get Territories """
func get_territories_in_confed(confed_id: int) -> Array[Territory]:
	# First we validate the confed_id passed in
	var confed: Confederation = get_confed_by_id(confed_id);
	if confed == null:
		return []; 
	
	var territories_list: Array[Territory];
	var queue: Array[Confederation] = [confed]
	var curr_confed: Confederation;
	# Setup Iteration Needs
	while not queue.is_empty():
		curr_confed = queue.pop_front();
			
		# Now we get the territories saved here, adding them to our returning list ensuring no duplicates
		for terr: Territory in curr_confed.Territory_List:
			if not territories_list.has(terr):
				territories_list.append(terr)
	
		# Now we iterate to children by adding them to the queue
		queue.append_array(curr_confed.Children);

	# Once we exit, we know we have all territories in confed 
	return territories_list;

""" Functions to Get Set of Teams """
## Get the Teams that are in the Tournament. Returns an empty array if error
func get_tournament_teams(tour_id: int) -> Array[Team]:
	# Get the Tournament and verify
	var tour: Tournament = get_tournament_by_id(tour_id);
	if tour == null:
		return [];
	var teams_in_tour: Array[Team] = tour.Teams;
	
	return teams_in_tour;

## Get the Teams that are in the Territory (not including the National Team). Returns an empty array if error
func get_territory_teams(terr_id: int) -> Array[Team]:
	#Verify ID
	if terr_id < 0 or terr_id >= Territories.size():
		return [];
		
	# Get Territory
	var terr: Territory = get_territory_by_id(terr_id);
	if terr == null:
		return [];
		
	return terr.Club_Teams_Rankings

""" Functions to Get Set of Players """
## Get the Players for the given team id. Returns an empty array if error
func get_team_roster(team_id: int) -> Array[Player]:
	# Get Team
	var team: Team = get_team_by_id(team_id);
	
	if team != null:
		return team.Players;
	
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


