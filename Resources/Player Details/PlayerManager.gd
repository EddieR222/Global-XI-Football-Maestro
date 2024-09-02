class_name PlayerManager extends Resource


""" Some constants for generating players """
const STARTING_TEAM_PLAYER_NUMBER: int = 35;

# Position Constants
const DEFENSE_POSITION_PROBABILITIES: Array[int] = [3,3,3,3,3,3,2,2,5,5,1,6,4];
const MIDFIELD_POSITION_PROBABILITIES: Array[int] = [8,8,9,7,11,10];
const ATTACK_POSITION_PROBABILITIES: Array[int] = [15,15,15,12,12,16,16,14,13];
const POSITION_CONVERSION: Dictionary = {
	0: "GK",
	1: "LWB",
	2: "LB",
	3: "CB",
	4: "SW",
	5: "RB",
	6: "RWB",
	7: "LM",
	8: "CM",
	9: "CDM",
	10: "CAM",
	11: "RM",
	12: "LW",
	13: "SS",
	14: "CF",
	15: "ST",
	16: "RW" 
};
const POSITION_NAME_CONVERSION: Dictionary = {
	"GK": 0,
	"LWB": 1,
	"LB": 2,
	"CB": 3,
	"SW": 4,
	"RB": 5,
	"RWB": 6,
	"LM": 7,
	"CM": 8,
	"CDM": 9,
	"CAM": 10,
	"RM": 11,
	"LW": 12,
	"SS": 13,
	"CF": 14,
	"ST": 15,
	"RW": 16
};

const POSITION_RELATIONS: Dictionary = {
	0: [],
	1: [2,2,2,3,6,6,7],
	2: [1,1,1,3,5,5],
	3: [4,4,4,2,5,9],
	4: [3],
	5: [6,6,6,2,2,3],
	6: [5,5,5,11,1,1,3],
	7: [12,1,11,11,8],
	8: [9,10,11,7],
	9: [8,3],
	10: [13,14,15,12,16,11,7],
	11: [7,7,8,16,6],
	12: [7,7,16,15,14],
	13: [14,15,10,12,16],
	14: [15,15,16,12,13],
	15: [14,14,12,16,13],
	16: [12,12,14,15,11] 
};

# Height Constants
const AVG_GK_HEIGHT: float = 190.0 #in cm
const AVG_DEF_HEIGHT: float = 184.0
const AVG_MID_HEIGHT: float = 177.0
const AVG_ATT_HEIGHT: float = 174.0
const HEIGHT_STD_DEV: float = 2.0

# Weight Constants
const AVG_GK_WEIGHT: float = 80.0 #in kg
const AVG_DEF_WEIGHT: float = 75.0
const AVG_MID_WEIGHT: float = 70.0
const AVG_ATT_WEIGHT: float = 68.0
const WEIGHT_STD_DEV: float = 5.0

# Rating Constants
const POTENTIAL_STD_DEV: float = 3.5;
const RATING_STD_DEV: float = 2.0;
const TERRITORY_STD_DEV: float = 8.0; # For when team isn't given
const BELOW_20_DIVISOR: float = 1.2;
const AT_20_DIVISOR: float = 1.05;

# Age Constants
const STARTING_AGES: Array[int] = [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35]


# Skill Move and Weak Foot Constants
const LOW_RATING: Array[int] = [40, 40, 8, 8, 4];
const MID_RATING: Array[int] = [5, 30, 30, 30, 5];
const HIGH_RATING: Array[int] = [4, 8, 8, 40, 40];

""" Cache Elements  """
# Foreign Nationalities Cache
var Foreign_Nation_Cache: Dictionary


func prepare_cache():
	# Here we iter through all territories
	for terr in GameMapManager.game_map.Territories:
		# Now we get the Foreign Nation Possbilities
		Foreign_Nation_Cache[terr.ID] = get_random_nationalities(terr.ID);

""" Mass Generating Functions """
## This function will create the entire roster for a team if given a team id
func generate_team_roster(team_id: int, num:= -1, percent_local:= -1, percent_foreign := -1) -> Dictionary:
	# First we need to get the team information
	var team: Team = GameMapManager.game_map.get_team_by_id(team_id);
	
	# Now we want to get the team rating and territory
	var team_rating: int = team.Rating;
	var team_terr: Territory = GameMapManager.game_map.get_territory_by_id(team._Territory);
	
	# Now we have to consider if both num_local and num_foreign are both -1. In this case we take an estimation 
	# to how many are local and how many are foreign
	if percent_local == -1 && percent_foreign == -1:
		percent_foreign = roundi(66 * (team_rating / 85));
		percent_local = 100 - percent_foreign;
		
	# Now we simply call the generate functions for different things
	var return_dict: Dictionary = {
		"Squad": generate_team_squad(team_id, percent_local, percent_foreign),
		"Subs": generate_team_subs(team_id, percent_local, percent_foreign),
		"Reserves": generate_team_reserves(team_id, percent_local, percent_foreign)
	}
	
	return return_dict

## This function generates N number of players for the given territory.[br]NO CLUB TEAM data will be given and most then be allocated as desired to teams
func generate_players_from_territory(terr_id: int, n:= 1) -> Array[Player]:
	# Create array to store players
	var player_roster: Array[Player] = [];
	player_roster.resize(n);
	
	
	# Now we simply generate n number of players
	for i in range(n):
		var parameters: Dictionary = {
			"Age": STARTING_AGES.pick_random(),
			"Pos": -1,
			"Terr_ID": terr_id,
			"Team_ID": -1,
			"Average Adjustment": 0.0,
			"Potential": -1
		}
		player_roster[i] = generate_player(parameters)
	
	# Now just return
	return player_roster

func generate_team_squad(team_id: int, percent_local:= -1, percent_foreign := -1) -> Array[Player]:
	# First we need to get the team information
	var team: Team = GameMapManager.game_map.get_team_by_id(team_id);
	
	# Now we want to get the team rating and territory
	var team_rating: int = 60 #team.Rating;
	var team_terr: Territory = GameMapManager.game_map.get_territory_by_id(40)   #team._Territory);
	
	# Now we have to consider if both num_local and num_foreign are both -1. In this case we take an estimation 
	# to how many are local and how many are foreign
	if percent_local == -1 && percent_foreign == -1:
		percent_foreign = roundi(66 * (team_rating / 85));
		percent_local = 100 - percent_foreign;
		
	# Calculate the number of local and foreign based on percentages passed in or estimated	
	var num_local: int = roundi(11 * (percent_local / 100.0))
	var num_foreign: int = 11 - num_local;
	
	# Now we want to get the Team Formation and the positions needed
	var positions: Array[String] = ["GK", "LB", "CB", "CB", "RB", "LM", "CM", "CM", "RM", "ST", "ST"] #team.Team_Tactics.Position_Names;
	positions.shuffle();
	
	# Prepare array to return with players
	var player_roster: Array[Player];
	player_roster.resize(11);

	# Generate the local players
	for i in range(num_local):
		var parameters: Dictionary = {
			"Age": STARTING_AGES.pick_random(),
			"Pos": POSITION_NAME_CONVERSION[positions.pop_back()],
			"Terr_ID": team_terr.ID,
			"Team_ID": team.ID,
			"Average Adjustment": 0.0,
			"Potential": -1
		}
		player_roster[i] = generate_player(parameters);

	# Generate the foregin players
	for j in range(num_local, 11):
		var terr_ids: Array = GameMapManager.game_map.Territories.filter(func(t: Territory): return t.ID != team_terr.ID).map(func(ter: Territory): return ter.ID);
		var weights_acc: Array[float] = Foreign_Nation_Cache[team_terr.ID];
		var weight_threshold := randf_range(0.0, weights_acc.back());
		var index: int = weights_acc.bsearch(weight_threshold);
		var parameters: Dictionary = {
			"Age": STARTING_AGES.pick_random(),
			"Pos": POSITION_NAME_CONVERSION[positions.pop_back()],
			"Terr_ID": terr_ids[index],
			"Team_ID": team.ID,
			"Average Adjustment": 0.0,
			"Potential": -1
		}
		player_roster[j] = generate_player(parameters);

	return player_roster

func generate_team_subs(team_id: int, percent_local:= -1, percent_foreign := -1) -> Array[Player]:
	# First we need to get the team information
	var team: Team = GameMapManager.game_map.get_team_by_id(team_id);
	
	# Now we want to get the team rating and territory
	var team_rating: int = team.Rating;
	var team_terr: Territory = GameMapManager.game_map.get_territory_by_id(team._Territory);
	
	# Now we have to consider if both num_local and num_foreign are both -1. In this case we take an estimation 
	# to how many are local and how many are foreign
	if percent_local == -1 && percent_foreign == -1:
		percent_foreign = roundi(66 * (team_rating / 85));
		percent_local = 100 - percent_foreign;
		
	# Calculate the number of local and foreign based on percentages passed in or estimated	
	var num_local: int = roundi(12 * (percent_local / 100.0))
	var num_foreign: int = 12 - num_local;
	
	# Now we want to get the Team Formation and the positions needed
	var positions: Array[String] =  ["GK", "LB", "CB", "CB", "RB", "LM", "CM", "CM", "RM", "ST", "ST", "GK"]#team.Team_Tactics.Position_Names;
	var extra_sub_position: String = positions.pick_random();
	positions.push_back(extra_sub_position);
	positions.shuffle();
	
	# Prepare array to return with players
	var player_roster: Array[Player];
	player_roster.resize(12);

	# Generate the local players
	for i in range(num_local):
		var parameters: Dictionary = {
			"Age": STARTING_AGES.pick_random(),
			"Pos": POSITION_NAME_CONVERSION[positions.pop_back()],
			"Terr_ID": team_terr.ID,
			"Team_ID": team.ID,
			"Average Adjustment": 2.0,
			"Potential": -1
		}
		player_roster[i] = generate_player(parameters);

	# Generate the foregin players
	for j in range(num_local, 12):
		var terr_ids: Array = GameMapManager.game_map.Territories.filter(func(t: Territory): return t.ID != team_terr.ID).map(func(ter: Territory): return ter.ID);
		var weights_acc: Array[float] = Foreign_Nation_Cache[team_terr.ID];
		var weight_threshold := randf_range(0.0, weights_acc.back());
		var index: int = weights_acc.bsearch(weight_threshold);
		var parameters: Dictionary = {
			"Age": STARTING_AGES.pick_random(),
			"Pos": POSITION_NAME_CONVERSION[positions.pop_back()],
			"Terr_ID": terr_ids[index],
			"Team_ID": team.ID,
			"Average Adjustment": 2.0,
			"Potential": -1
		}
		player_roster[j] = generate_player(parameters);

	return player_roster

func generate_team_reserves(team_id: int, percent_local:= -1, percent_foreign := -1) -> Array[Player]:
	# First we need to get the team information
	var team: Team = GameMapManager.game_map.get_team_by_id(team_id);
	
	# Now we want to get the team rating and territory
	var team_rating: int = team.Rating;
	var team_terr: Territory = GameMapManager.game_map.get_territory_by_id(team._Territory);
	
	# Now we have to consider if both num_local and num_foreign are both -1. In this case we take an estimation 
	# to how many are local and how many are foreign
	if percent_local == -1 && percent_foreign == -1:
		percent_foreign = roundi(66 * (team_rating / 85));
		percent_local = 100 - percent_foreign;
		
	# Calculate the number of local and foreign based on percentages passed in or estimated
	var reserve_size: int = STARTING_TEAM_PLAYER_NUMBER - 23
	var num_local: int = roundi(reserve_size * (percent_local / 100.0))
	var num_foreign: int = reserve_size - num_local;
	
	# Now we want to get the Team Formation and the positions needed
	var positions: Array[String] = team.Team_Tactics.Position_Names;
	var copy: Array[String] = team.Team_Tactics.Position_Names;
	while positions.size() < reserve_size: 
		positions.push_back(copy.pick_random());
	positions.shuffle();
	
	# Prepare array to return with players
	var player_roster: Array[Player];
	player_roster.resize(reserve_size);

	# Generate the local players
	for i in range(num_local):
		var parameters: Dictionary = {
			"Age": STARTING_AGES.pick_random(),
			"Pos": POSITION_NAME_CONVERSION[positions.pop_back()],
			"Terr_ID": team_terr.ID,
			"Team_ID": team.ID,
			"Average Adjustment": 5.0,
			"Potential": -1
		}
		player_roster[i] = generate_player(parameters);

	# Generate the foregin players
	for j in range(num_local, reserve_size):
		var terr_ids: Array = GameMapManager.game_map.Territories.filter(func(t: Territory): return t.ID != team_terr.ID).map(func(ter: Territory): return ter.ID);
		var weights_acc: Array[float] = Foreign_Nation_Cache[team_terr.ID];
		var weight_threshold := randf_range(0.0, weights_acc.back());
		var index: int = weights_acc.bsearch(weight_threshold);
		var parameters: Dictionary = {
			"Age": STARTING_AGES.pick_random(),
			"Pos": POSITION_NAME_CONVERSION[positions.pop_back()],
			"Terr_ID": terr_ids[index],
			"Team_ID": team.ID,
			"Average Adjustment": 5.0,
			"Potential": -1
		}
		player_roster[j] = generate_player(parameters);

	return player_roster

func generate_youth_academy(team_id: int, num: int, percent_local:= -1, percent_foreign := -1) -> Array[Player]:
	# First we need to get the team information
	var team: Team = GameMapManager.game_map.get_team_by_id(team_id);
	
	# Now we want to get the team rating and territory
	var team_rating: int = team.Rating;
	var team_terr: Territory = GameMapManager.game_map.get_territory_by_id(team._Territory);
	
	# Now we have to consider if both num_local and num_foreign are both -1. In this case we take an estimation 
	# to how many are local and how many are foreign
	if percent_local == -1 && percent_foreign == -1:
		percent_foreign = roundi(66 * (team_rating / 85));
		percent_local = 100 - percent_foreign;
		
	# Calculate the number of local and foreign based on percentages passed in or estimated	
	var num_local: int = roundi(12 * (percent_local / 100.0))
	var num_foreign: int = 12 - num_local;
	
	# Now we want to get the Team Formation and the positions needed
	var positions: Array[String] = team.Team_Tactics.Position_Names;
	var extra_sub_position: String = positions.pick_random();
	positions.push_back(extra_sub_position);
	positions.shuffle();
	
	# Prepare array to return with players
	var player_roster: Array[Player];
	player_roster.resize(12);

	# Generate the local players
	for i in range(num_local):
		var parameters: Dictionary = {
			"Age": STARTING_AGES.pick_random(),
			"Pos": POSITION_NAME_CONVERSION[positions.pop_back()],
			"Terr_ID": team_terr.ID,
			"Team_ID": team.ID,
			"Average Adjustment": 2.0,
			"Potential": -1
		}
		player_roster[i] = generate_player(parameters);

	# Generate the foregin players
	for j in range(num_local, 12):
		var terr_ids: Array = GameMapManager.game_map.Territories.filter(func(t: Territory): return t.ID != team_terr.ID).map(func(ter: Territory): return ter.ID);
		var weights_acc: Array[float] = Foreign_Nation_Cache[team_terr.ID];
		var weight_threshold := randf_range(0.0, weights_acc.back());
		var index: int = weights_acc.bsearch(weight_threshold);
		var parameters: Dictionary = {
			"Age": STARTING_AGES.pick_random(),
			"Pos": POSITION_NAME_CONVERSION[positions.pop_back()],
			"Terr_ID": terr_ids[index],
			"Team_ID": team.ID,
			"Average Adjustment": 2.0,
			"Potential": -1
		}
		player_roster[j] = generate_player(parameters);

	return player_roster
	
	
""" Generate Single Player """
## This function will create one player with the given paramaters.[br]
## The parameters are passed in via a dictionary that is built depending on what we want to do[br]
## Parameters:[br]
## Age: int
## Pos: int
## Terr_ID: int
## Team_ID: int
## Average Adjustment: float
## Potential: int
# TODO: Figure out how to connet signals here 
func generate_player(parameters: Dictionary) -> Player:
	# First thing first, we need to get all the parameter values
	var age: int = parameters["Age"]
	var pos: int = parameters["Pos"]
	var terr_id: int = parameters["Terr_ID"]
	var team_id: int = parameters["Team_ID"]
	var average_adjustment: float = parameters["Average Adjustment"]
	var potential_override: int = parameters["Potential"]
	
	# DEBUG
	if pos == 8:
		print("8!!")
	
	# Next, create the instance of the player to be created
	var player: Player = Player.new();
	
	# Set player age
	# var x = (value) if (expression) else (value)
	player.Age = age if age != null else STARTING_AGES.pick_random();
		
	# Set Player Birthday
	var current_date: Array[int] = GameMapManager.game_map.Date;
	player.BirthDate = [randi() % current_date[0], randi() % current_date[1], current_date[2] - age]
	
	# Now we determine the position(s) of the player (whether passed in or not)
	determine_player_position(pos, player);

	# Now we determine whether the player is left or right footed
	var foot_chance: int = randi() % 100;
	player.Right_Foot = true if foot_chance < 15 else false;

	# Now we determine the player's nationality (or nationalities) 
	determine_player_nationality(terr_id, player);
		
	# Now we determine the Potential and Overall of the Player
	determine_player_ratings(team_id, potential_override, player, average_adjustment);

	# Now we get the player name
	determine_player_name(player)
	
	# Now we get a random player face
	determine_player_face(player)
		
	# Now we determine their skill move and weak foot star levels
	player.Skill_Moves = determine_stars(player.Overall);
	player.Weak_Foot = determine_stars(player.Overall);
		
	# Finally return player we created
	return player
		

""" Generating Single Player Helper Functions """
## Given a territory id, this will return a random and likely nation for the league of the territory id passed in.[br]
## For the most part this will depend on randomness and the league elo of the territory and those below it
func get_random_nationalities(terr_id: int) -> Array[float]:
	# First we simply need to get the territory passed in
	var terr: Territory = GameMapManager.game_map.get_territory_by_id(terr_id);
	
	# Now, we need to get the league elo ratings for all territories in the game
	var terr_ids: Array = GameMapManager.game_map.Territories.filter(func(terr: Territory): return terr.ID != terr_id).map(func(terr: Territory): return terr.ID);
	terr_ids.sort();
	var terr_league_elos: Array = GameMapManager.game_map.Territories.filter(func(terr: Territory): return terr.ID != terr_id).map(func(terr: Territory): return terr.League_Elo);
	var confed_territories: Array = GameMapManager.game_map.get_confeds_of_territory(terr_id)
	
	# Now we adjust the weights
	# 1. If a country has a higher elo than our country, cap them to our countries elo and then decrease them on the ratio of their difference to the original elo
	# 2. For countries with zero league elo, we make it 2 since they can be in any league
	# 3. For countries that share a confederation with this country (excluding the world confed) we increase their chances by 50%
	for index in range(terr_league_elos.size()):
		var elo: int = terr_league_elos[index];
		
		if elo > terr.League_Elo:
			terr_league_elos[index] = float(terr.League_Elo * (terr.League_Elo / elo));
			
		if elo < 1:
			terr_league_elos[index] = 2.0;
		
	var curr_confed: Confederation;
	var visited_terr: Array[int] = [terr.ID]
	var close_ness_percent: float = 1.0;
	while not confed_territories.is_empty():
		# Get last confed so it is the bottom and where the country originates from (Example: India is in South Asia)
		curr_confed = confed_territories.pop_back();
		
		# Now for each terr_id, we increase their chances to the maximum (terr.league_elo) and then slowly decrease form there
		for curr_terr: Territory in curr_confed.Territory_List:
			# Check if we already shifted values
			if curr_terr.ID in visited_terr:
				continue
				
			# Now we simply find its index and change
			var terr_elo_index: int = terr_ids.find(curr_terr.ID);
			var elo: float = terr_league_elos[terr_elo_index]
			terr_league_elos[terr_elo_index] = max(elo, (terr.League_Elo * close_ness_percent)); # * (elo/terr.League_Elo));
			visited_terr.append(curr_terr.ID);
			
		close_ness_percent -= .10;
			
	# Now we need to do the weighted probabilities array
	var weights_acc: Array[float] = [];
	weights_acc.resize(terr_league_elos.size());
	var weights_sum := 0.0
	for i in weights_acc.size():
		weights_sum += terr_league_elos[i]
		weights_acc[i] = weights_sum
		
	return weights_acc;

## This function simply determines the number of stars for Skill Moves and Weak Foot. It calculates it using different weighted probability distrobutions depending
## on the rating of the player. Will ALWAYS give at least 1 star and a maximum of 5
func determine_stars(rating: int) -> int:
	var star_distribution: Array[int] = [];
	if rating < 33:
		star_distribution = LOW_RATING;
	elif rating < 66:
		star_distribution = LOW_RATING;
	else:
		star_distribution = HIGH_RATING;
		
		
	var weights_acc: Array[float] = [];
	weights_acc.resize(star_distribution.size());
	var weights_sum := 0.0
	for i in weights_acc.size():
		weights_sum += star_distribution[i]
		weights_acc[i] = weights_sum
	
	var weight_threshold := randf_range(0.0, weights_acc.back());
	var index: int = weights_acc.bsearch(weight_threshold);
	if index + 1 == 0:
		print("ERROR")
	return index + 1

## This function takes in a position and a Player and determines what their position should be. This also determines the height and weight of the player based on their position.[br]
## There is also a small chance that the player can have mulltiple positions
func determine_player_position(pos: int, player: Player) -> void:
	
	# First we have to generate some random values
	var position_chance: int = randi() % 100; #get random integer between 0 and 100
	if pos == 0:
		position_chance = 9;
	elif pos < 7:
		position_chance = 35;
	elif pos < 12:
		position_chance = 70;
	else:
		position_chance = 90
		

	# Now we determine position, height, and weight
	# Here height and weight use a normal distribution using the const mean and std dev defined above
	if position_chance < 10:
		var positions_array: Array[int] = [0];
		player.Positions = positions_array
		player.Height = roundi(randfn(AVG_GK_HEIGHT, HEIGHT_STD_DEV));
		player.Weight = roundi(randfn(AVG_GK_WEIGHT, WEIGHT_STD_DEV));
	elif position_chance < 37:
		if pos != -1:
			player.Positions = [pos]
		else:
			player.Positions = [DEFENSE_POSITION_PROBABILITIES.pick_random()]
		player.Height = roundi(randfn(AVG_DEF_HEIGHT, HEIGHT_STD_DEV));
		player.Weight = roundi(randfn(AVG_DEF_WEIGHT, WEIGHT_STD_DEV));
	elif position_chance < 73:
		if pos != -1:
			player.Positions = [pos]
		else:
			player.Positions = [MIDFIELD_POSITION_PROBABILITIES.pick_random()]
		player.Height = roundi(randfn(AVG_MID_HEIGHT, HEIGHT_STD_DEV));
		player.Weight = roundi(randfn(AVG_MID_WEIGHT, WEIGHT_STD_DEV));
	else:
		if pos != -1:
			player.Positions = [pos]
		else:
			player.Positions = [ATTACK_POSITION_PROBABILITIES.pick_random()]
		player.Height = roundi(randfn(AVG_ATT_HEIGHT, HEIGHT_STD_DEV));
		player.Weight = roundi(randfn(AVG_ATT_WEIGHT, WEIGHT_STD_DEV));

	
	# Now we will decide if the player shoule have a second or even third alternative positions
	var multiple_position_chance: int = randi() % 100;
	if multiple_position_chance < 40:
		var related_positions: Array = POSITION_RELATIONS[player.Positions[0]];
		player.Positions.push_back(related_positions.pick_random())
		related_positions.filter(func(e: int): return e != player.Positions[1])
		if multiple_position_chance < 6:
			player.Positions.push_back(related_positions.pick_random())
			
			
	# Now we are done with deciding position(s) for the player
	return 

## This function determines the nationalities of the player. This takes care of CoTerritories and even a small chance to get a random additional territory
func determine_player_nationality(terr_id: int, player: Player) -> void:
	# First, if no territory is given, we need to randomly select a territory for it
	if terr_id == -1:
		terr_id = GameMapManager.game_map.Territories.pick_random().ID;
		
	# Now, we can be sure that the terr_id is a valid county and we can add it as a nationality
	player.Nationalities = [terr_id];
	
	# Now, we see if the territory has any CoTerritories
	var terr: Territory = GameMapManager.game_map.get_territory_by_id(terr_id)
	if terr.CoTerritory != null:
		player.Nationalities.push_back(terr.CoTerritory.ID);
		
	# Regardless of CoTerritories, there is a small chance players have another nationality
	var random_nation_chancee: int = randi() % 101;
	if random_nation_chancee < 20:
		var terr_ids: Array = GameMapManager.game_map.Territories.filter(func(t: Territory): return t.ID != terr.ID).map(func(t: Territory): return t.ID);
		var weights_acc: Array[float] = Foreign_Nation_Cache[terr.ID];
		var weight_threshold := randf_range(0.0, weights_acc.back());
		var index: int = weights_acc.bsearch(weight_threshold);
		player.Nationalities.push_back(terr_ids[index]);
		
	
	return

## This function determines the Potential and Overall of the player depending on random values such as nationalities, club team, and other factors
func determine_player_ratings(team_id: int, potential_override: int,  player: Player, average_adjustment:= 0.0) -> void:
	var potential: float;
	# There are two ways to determine potential, one is by the override if that was given a value. 
	if potential_override >= 0:
		# This is the override, we simply give the player the potential which was passed in
		player.Potential = potential_override
	else:
		# Here we calculate the base_rating for the player based on their nationalities
		var player_nationality_rating: Array = player.Nationalities.map(func(id: int): return GameMapManager.game_map.get_territory_by_id(id).Rating);
		var base_rating: int = player_nationality_rating.pop_front();
		for rating in player_nationality_rating:
			var adjustment: int = roundi(float(rating - base_rating) / 10.0);
			base_rating += adjustment
	
		if team_id == -1: 
			# No team was given so just use Territory Rating as average rating 
			# Determine potential and ensure its withtin the range of 10 - 94
			potential = randfn(base_rating, TERRITORY_STD_DEV);
			while potential > 94.0 || potential < 10.0:
				potential = randfn(base_rating, TERRITORY_STD_DEV);
				
		else:
			# Team is given so use that and Territory Rating to determine mean potential for player
			player.Club_Team = team_id
			var player_team: Team = GameMapManager.game_map.get_team_by_id(team_id)
			
			# Use both team and nationality rating tp determine mean potential for player
			var terr_rating_adjustment: int = roundi((base_rating - player_team.Rating) / 10.0);
			var mean_rating: float =  float(player_team.Rating + terr_rating_adjustment);
			
			# Find potential rating and ensure its within range of 10-94
			potential = randfn(mean_rating, POTENTIAL_STD_DEV);
			while potential > 94.0 || potential < 10.0:
				potential = randfn(mean_rating, POTENTIAL_STD_DEV);
				
		# Save Player's Potential
		player.Potential = roundi(potential)
	

	# Now find current rating based on age
	var curr_rating: int = 0;
	if player.Age < 20:
		curr_rating = roundi(randfn((player.Potential / BELOW_20_DIVISOR) - average_adjustment, RATING_STD_DEV));
	elif player.Age < 26: 
		curr_rating = roundi(randfn((player.Potential / AT_20_DIVISOR) - average_adjustment, RATING_STD_DEV));
	elif player.Age < 33: 
		curr_rating = roundi(randfn(player.Potential - average_adjustment, RATING_STD_DEV));
	else:
		curr_rating = roundi(randfn(player.Potential - average_adjustment, RATING_STD_DEV) * (1.0 -  ((player.Age - 32) * 1.2) ));
	player.Overall = curr_rating if curr_rating < 99 and curr_rating > 1 else -1
	
	return

## This function determines the Full Name of the Player
func determine_player_name(player: Player) -> void:
	# Get player terr
	var player_terr: Territory = GameMapManager.game_map.get_territory_by_id(player.Nationalities[0]);
	
	# Now we get the player's name
	var middle_chance: int = randi() % 101;
	var first_name: String = "e"
	var middle_name: String = "e"
	var last_name: String = "e"
	while first_name == last_name || middle_name == last_name || middle_name == first_name:
		first_name = player_terr.First_Names.pick_random();
		last_name = player_terr.Last_Names.pick_random();
		middle_name = player_terr.Last_Names.pick_random();
			
	if middle_chance < 50:
		player.Name =  first_name.strip_edges() + " " + middle_name.strip_edges() + " " + last_name.strip_edges();
	else:
		player.Name = first_name.strip_edges() + " " + last_name.strip_edges();

func determine_player_face(player: Player) -> void:
	# First we need to load a player face randomly
	# INFO: For now, we use premade generated faces
	var player_face: Image = get_random_player_face("res://Images/PlayerFaces/");
	player.save_face_for_player(player_face)
	
	return
	
func get_random_player_face(dir_path: String) -> Image:
	# Open the directory
	var dir: DirAccess = DirAccess.open(dir_path);
	
	# Get Files
	var player_faces_orig = dir.get_files();
	var player_faces: Array[String];
	for file_name: String in player_faces_orig:
		if not file_name.ends_with("import"):
			player_faces.push_back(file_name)
	
	# Pick random one and load it
	var random_image: Image = Image.load_from_file(dir_path + player_faces.pick_random())
	
	if random_image != null:
		return random_image
	
	return null



""" Static Functions """
static func convert_to_string_position(pos: int) -> String:
	if pos >= 0 and pos <= 16: 
		return POSITION_CONVERSION[pos]
	return ""
	
static func convert_to_int_position(pos: String) -> int:
	if pos in POSITION_NAME_CONVERSION.keys():
		return POSITION_NAME_CONVERSION[pos];
	return -1;
