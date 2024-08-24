class_name PlayerManager extends Resource


""" Game Map """
@export var game_map: GameMap;


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


func _init(gm: GameMap):
	# Now we set the game_map memeber
	game_map = gm;

	# Here we iter through all territories
	for terr in gm.Territories:
		# Now we get the Foreign Nation Possbilities
		Foreign_Nation_Cache[terr.ID] = get_random_nationalities(terr.ID);

### This function will create the entire roster for a team if given a team id
#func generate_team_roster(team_id: int, num:= -1, percent_local:= -1, percent_foreign := -1) -> Array[Player]:
	## First we need to get the team information
	#var team: Team = game_map.get_team_by_id(team_id);
	#
	## Now we want to get the team rating and territory
	#var team_rating: int = team.Rating;
	#var team_terr: Territory = game_map.get_territory_by_id(team.Territory_ID);
	#
	## Now we have to consider if both num_local and num_foreign are both -1. In this case we take an estimation 
	## to how many are local and how many are foreign
	#if percent_local == -1 && percent_foreign == -1:
		#percent_foreign = roundi(66 * (team_rating / 85));
		#percent_local = 100 - percent_foreign;
		#
	## Calculate the number of local and foreign based on percentages passed in or estimated
	#var num_local: int;
	#var num_foreign: int;
	#if num != -1:
		#num_local = roundi(num * (percent_local / 100.0))
		#num_foreign = num - num_local;
	#else:
		#num_local = roundi(STARTING_TEAM_PLAYER_NUMBER * (percent_local / 100.0))
		#num_foreign = STARTING_TEAM_PLAYER_NUMBER - num_local;
	#
	## Now we simply call the create player function with the number of local and number of foreign
	#var player_roster: Array[Player] = [];
	#if num != -1:
		#player_roster.resize(num);
	#else:
		#player_roster.resize(STARTING_TEAM_PLAYER_NUMBER)
	#
	#for i in range(num_local):
		#player_roster[i] = generate_player(STARTING_AGES.pick_random(), team_terr.Territory_ID, team_id);
		#
	#for j in range(num_local, STARTING_TEAM_PLAYER_NUMBER):
		#var terr_ids: Array = game_map.Territories.filter(func(terr: Territory): return terr.Territory_ID != team_terr.Territory_ID).map(func(terr: Territory): return terr.Territory_ID);
		#var weights_acc: Array[float] = Foreign_Nation_Cache[team_terr.Territory_ID];
		#var weight_threshold := randf_range(0.0, weights_acc.back());
		#var index: int = weights_acc.bsearch(weight_threshold);
		#player_roster[j] = generate_player(STARTING_AGES.pick_random(), terr_ids[index] , team_id);
		#
	## Finally just return player list
	#return player_roster
#
### This function generates N number of players for the given territory.[br]NO CLUB TEAM data will be given and most then be allocated as desired to teams
#func generate_players_from_territory(terr_id: int, n:= 1) -> Array[Player]:
	## Create array to store players
	#var player_roster: Array[Player] = [];
	#player_roster.resize(n);
	#
	#
	## Now we simply generate n number of players
	#for i in range(n):
		#player_roster[i] = generate_player(STARTING_AGES.pick_random(), terr_id)
	#
	## Now just return
	#return player_roster
#
#
	#
#
### This function generates players for all the teams in the territory passed in
#func generate_entire_territory_players(terr_id: int) -> Array[Player]:
	## First we need to get a list of all the teams in this territory
	#
	#
	#
	#
	#return [];
	#
	#
	#
#func generate_entrie_database() -> Array[Player]:
	##Generate the array that will hold all players
	#var player_list: Array[Player];
	##var player_list_sq: Array[Array[Player]];
	#
	#
	## Now we go through all Teams and generate players for them
	#for team in game_map.Teams:
		#player_list.append_array(generate_team_roster(team.ID));
	##var task_id = WorkerThreadPool.add_group_task(generate_team_roster, enemies.size())
	#
	#
	#return player_list
	#
#

## This function will create one player with the given paramaters.[br]
## The parameters are passed in via a dictionary that is built depending on what we want to do[br]
## Parameters:[br]
## Age: int
## Pos: int
## Terr_ID: int
## Team_ID: int

func generate_player(parameters: Dictionary) -> Player:
	# First thing first, we need to get all the parameter values
	var age: int = parameters["Age"]
	var pos: int = parameters["Pos"]
	var terr_id: int = parameters["Terr_ID"]
	var team_id: int = parameters["Team_ID"]
	
	# Next, create the instance of the player to be created
	var player: Player = Player.new();
	
	# Set player age
	# var x = (value) if (expression) else (value)
	player.Age = age if age != null else STARTING_AGES.pick_random();
		
	
	# Set Player Birthday
	var current_date: Array[int] = game_map.Date;
	player.BirthDate = [randi() % current_date[0], randi() % current_date[1], current_date[2] - age]
	
	# Now we determine the position(s) of the player (whether passed in or not)
	determine_player_position_and_rating(pos, player);

	# Now we determine whether the player is left or right footed
	var foot_chance: int = randi() % 101;
	player.Right_Foot = true if foot_chance < 15 else false;

	# Now we need to determine the player's rating. We do this by using the player's nationality
	# and their team's average rating 
	var player_terr : Territory;
	var potential: float;
	
	
	# If Terr_ID is left empty, we will randomly choose a territory for the player
	if terr_id == -1:
		terr_id = game_map.Territories.pick_random().ID;
		
		
	if team_id == -1: # No team was given so just use Territory Rating as average rating 
		# Set Nationality of Player
		player.add_player_nationality(terr_id);
		player_terr = game_map.get_territory_by_id(terr_id);
		
		# Determine potential and ensure its withtin the range of 10 - 94
		potential = randfn(66, TERRITORY_STD_DEV);
		while potential > 94 || potential < 10:
			potential = randfn(player_terr.Rating, TERRITORY_STD_DEV);
			
	else: # Team is given so use that and Territory Rating to determine mean potential for player
		# Set Nationality AND Team of Player
		player.add_player_nationality(terr_id);
		player.set_player_club_team(team_id);
		
		var player_team: Team = game_map.get_team_by_id(team_id)
		player_terr = game_map.get_territory_by_id(terr_id)
		
		# Use both team and nationality rating tp determine mean potential for player
		var terr_rating_adjustment: int = roundi((player_terr.Rating - player_team.Rating) / 10.0);
		var mean_rating: float =  float(player_team.Rating + terr_rating_adjustment);
		
		
		# Find potential rating and ensure its within range of 10-94
		potential = randfn(mean_rating, POTENTIAL_STD_DEV);
		while potential > 94 || potential < 10:
			potential = randfn(mean_rating, POTENTIAL_STD_DEV);
			
	# Save Player's Potential
	player.set_player_potential_rating(roundi(potential));
	

	# Now find current rating based on age
	var curr_rating: int = 0;
	while curr_rating > potential || curr_rating < 1:
		if age < 20:
			curr_rating = roundi(randfn(potential / BELOW_20_DIVISOR, RATING_STD_DEV));
		elif age < 26: 
			curr_rating = roundi(randfn(potential / AT_20_DIVISOR, RATING_STD_DEV));
		elif age < 33: 
			curr_rating = roundi(randfn(potential, RATING_STD_DEV));
		else:
			curr_rating = roundi(randfn(potential, RATING_STD_DEV) - ((age - 32) * 1.2) );
	player.set_player_overall_rating(curr_rating);
	
	
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
		player.set_player_name(first_name.strip_edges() + " " + middle_name.strip_edges() + " " + last_name.strip_edges());
	else:
		player.set_player_name(first_name.strip_edges() + " " + last_name.strip_edges());
		
		
	# Now we determine their skill move and weak foot star levels
	player.set_player_skill_moves(determine_stars(curr_rating));
	player.set_player_weak_foot(determine_stars(curr_rating));
		
		
	# Finally return player we created
	return player
		

## Given a territory id, this will return a random and likely nation for the league of the territory id passed in.[br]
## For the most part this will depend on randomness and the league elo of the territory and those below it
func get_random_nationalities(terr_id: int) -> Array[float]:
	# First we simply need to get the territory passed in
	var terr: Territory = game_map.get_territory_by_id(terr_id);
	
	# Now, we need to get the league elo ratings for all territories in the game
	var terr_ids: Array = game_map.Territories.filter(func(terr: Territory): return terr.Territory_ID != terr_id).map(func(terr: Territory): return terr.Territory_ID);
	terr_ids.sort();
	var terr_league_elos: Array = game_map.Territories.filter(func(terr: Territory): return terr.Territory_ID != terr_id).map(func(terr: Territory): return terr.League_Elo);
	var confed_territories: Array = game_map.get_confeds_of_territory(terr_id).map(func(confed_id: int): return game_map.get_confed_by_id(confed_id));
	
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
	var visited_terr: Array[int] = [terr.Territory_ID]
	var close_ness_percent: float = 1.0;
	while not confed_territories.is_empty():
		# Get last confed so it is the bottom and where the country originates from (Example: India is in South Asia)
		curr_confed = confed_territories.pop_back();
		
		# Now for each terr_id, we increase their chances to the maximum (terr.league_elo) and then slowly decrease form there
		for id in curr_confed.Territory_List:
			# Check if we already shifted values
			if id in visited_terr:
				continue
				
			# Now we simply find its index and change
			var terr_elo_index: int = terr_ids.find(id);
			var elo: float = terr_league_elos[terr_elo_index]
			terr_league_elos[terr_elo_index] = max(elo, (terr.League_Elo * close_ness_percent)); # * (elo/terr.League_Elo));
			visited_terr.append(id);
			
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

	
	
func determine_player_position_and_rating(pos: int, player: Player) -> void:
	
	# First we have to generate some random values
	var position_chance: int = randi() % 101; #get random integer between 0 and 100
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
		player.Positions = [0];
		player.Height = roundi(randfn(AVG_GK_HEIGHT, HEIGHT_STD_DEV));
		player.Weight = roundi(randfn(AVG_GK_WEIGHT, WEIGHT_STD_DEV));
	elif position_chance < 37:
		player.Positions = [pos] if pos != -1 else [DEFENSE_POSITION_PROBABILITIES.pick_random()];
		player.Height = roundi(randfn(AVG_DEF_HEIGHT, HEIGHT_STD_DEV));
		player.Weight = roundi(randfn(AVG_DEF_WEIGHT, WEIGHT_STD_DEV));
	elif position_chance < 73:
		player.Positions = [pos] if pos != -1 else [MIDFIELD_POSITION_PROBABILITIES.pick_random()];
		player.Height = roundi(randfn(AVG_MID_HEIGHT, HEIGHT_STD_DEV));
		player.Weight = roundi(randfn(AVG_MID_WEIGHT, WEIGHT_STD_DEV));
	else:
		player.Positions = [pos] if pos != -1 else [ATTACK_POSITION_PROBABILITIES.pick_random()];
		player.Height = roundi(randfn(AVG_ATT_HEIGHT, HEIGHT_STD_DEV));
		player.Weight = roundi(randfn(AVG_ATT_WEIGHT, WEIGHT_STD_DEV));

	
	# Now we will decide if the player shoule have a second or even third alternative positions
	var multiple_position_chance: int = randi() % 101;
	if multiple_position_chance < 40:
		var related_positions: Array[int] = POSITION_RELATIONS[player.Positions[0]];
		player.Positions.push_back(related_positions.pick_random())
		related_positions.filter(func(e: int): return e != player.Positions[1])
		if multiple_position_chance < 6:
			player.Positions.push_back(related_positions.pick_random())
			
			
	# Now we are done with deciding position(s) for the player
	return 
		
