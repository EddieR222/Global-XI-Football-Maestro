class_name GameMap extends Resource
## The File that contains all information for the game
##
## This Class contains all the information for the game including territories, confederations, teams, tournaments, etc.
## It also contains a lot of useful functions for parsing and working with this data

@export_category("World Map")
## The Dictionary that contains all Confederations. 
@export 
var Confederations: Array[Confederation] = [];
## The Dictionary that contains all Territories. 
@export 
var Territories: Array[Territory] = [];

@export_category("Team Details")
## The Dictionary that contains all Teams. 
@export
var Teams: Array[Team] = [];

## The Dictionary that contains all Stadiums. 
@export
var Stadiums: Array[Stadium] = [];

@export_category("Tournament Details")
## The Dictionary that contains all Tournaments.
@export
var Tournaments: Array[Tournament] = [];


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

""" Sorting and ID managment """
## This functions sorts the confederations in alphabetical order by name. 
## Also changes IDs based on new alphabetical order
func sort_confederations() -> void:
	# Create Index and RID dictionary
	var rid_dict: Dictionary = {}
	var index: int = 0;
	for confed: Confederation in Confederations:
		rid_dict[index] = confed.get_rid();
		index += 1;
	
	# Sort the array based on Name (Alphabetical Order)
	Confederations.sort_custom(func(a: Confederation, b: Confederation): return a.Name < b.Name);
	
	# Now update the ID of each Territory, based on index in Array
	var new_index = 0;
	for confed: Confederation in Confederations:
		confed.ID = new_index;
		new_index += 1;
	
	# Now we have to update this new confed_id everywhere in this GameMap	
	for old_index: int in rid_dict.keys():
		var unique_rid: RID = rid_dict[old_index]
		for new_confed: Confederation in Confederations:
			if new_confed.get_rid() == unique_rid:
				update_confederation_id(old_index, new_confed.ID)
				break
				
	
	
## This functions sorts the territories in alphabetical order by name. 
## Also changes IDs based on new alphabetical order
func sort_territories() -> void:
	# Create Index and RID dictionary
	var rid_dict: Dictionary = {}
	var index: int = 0;
	for terr: Territory in Territories:
		rid_dict[index] = terr.get_rid();
		index += 1;
	
	# Sort the array based on Name (Alphabetical Order)
	Territories.sort_custom(func(a: Territory, b: Territory): return a.Territory_Name < b.Territory_Name);
	
	# Now update the ID of each Territory, based on index in Array
	var new_index = 0;
	for terr: Territory in Territories:
		terr.Territory_ID = new_index;
		new_index += 1;
		
	# Now we have to update this new territory_id everywhere in this GameMap
	for old_index: int in rid_dict.keys():
		var unique_rid: RID = rid_dict[old_index]
		for new_terr: Territory in Territories:
			if new_terr.get_rid() == unique_rid:
				update_territory_id(old_index, new_terr.Territory_ID);
				break


## This functions sorts the teams in alphabetical order by name. 
## Also changes IDs based on new alphabetical order
func sort_teams() -> void:
	# Sort the array based on Name (Alphabetical Order)
	Teams.sort_custom(func(a: Team, b: Team): return a.Name < b.Name);
	
	# Now update the ID of each Territory, based on index in Array
	var index = 0;
	for team: Team in Teams:
		team.ID = index;
		index += 1;

## This functions sorts the tournaments in alphabetical order by name. 
## Also changes IDs based on new alphabetical order
func sort_tournaments() -> void:
	# Sort the array based on Name (Alphabetical Order)
	Tournaments.sort_custom(func(a: Tournament, b: Tournament): return a.Name < b.Name);
	
	# Now update the ID of each Territory, based on index in Array
	var index = 0;
	for tour: Tournament in Tournaments:
		tour.ID = index;
		index += 1;
		
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
	
## This functions erases the team by id (the confed id). 
## Array automatically will sort and organize id's after deletion
func erase_team_by_id(id: int) -> void:
	if id < 0 or id >= Teams.size():
		return 
		
	# Remove at index
	Teams.remove_at(id);
	
	# Resort all territories
	sort_teams();
	
## This functions erases the tournament by id (the confed id). 
## Array automatically will sort and organize id's after deletion
func erase_tournament_by_id(id: int) -> void:
	if id < 0 or id >= Tournaments.size():
		return 
		
	# Remove at index
	Tournaments.remove_at(id);
	
	# Resort all territories
	sort_tournaments();
	
""" Updating IDs Across GameMap """
## This function updates the old territory ID to the new one across the Entire GameMap
func update_territory_id(old_id: int, new_id: int) -> void:
	# First we update the territory IDs in all confederations
	for confed: Confederation in Confederations:
		confed.update_territory_id(old_id, new_id); 

	# Second, we update all Territory Id's in Teams
	for team: Team in Teams:
		if team.Territory_ID == old_id:
			team.Territory_ID = new_id;

	# Finally, we update all Territory Id's in Tournaments
	for tour: Tournament in Tournaments:
		if tour.Host_Country_ID == old_id:
			tour.Host_Country_ID = new_id;

## This function updates the old confed ID to the new one across the Entire GameMap
func update_confederation_id(old_id: int, new_id: int) -> void:
	# Thankfully, only need uopdating in Confederations themselves
	# We iter through All Confederations, and update Owner and Children ID 
	for confed: Confederation in Confederations:
		# Update Children if old_id is present
		var index_to_change: int = confed.Children_ID.find(old_id);
		if index_to_change != -1:
			confed.Children_ID[index_to_change] = new_id
			
		# Update Owner ID if it is old_id
		if confed.Owner_ID == old_id:
			confed.Owner_ID = new_id;
		
