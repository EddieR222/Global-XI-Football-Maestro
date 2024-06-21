class_name PlayerManager extends Resource


""" Game Map """
@export var game_map: GameMap;


""" Some constants for generating players """
const STARTING_TEAM_PLAYER_NUMBER: int = 35;


# Position Constants
const DEFENSE_POSITION_PROBABILITIES: Array[int] = [3,3,3,3,3,3,2,2,4,4,1,5];
const MIDFIELD_POSITION_PROBABILITIES: Array[int] = [7,7,9,8,6,10];
const ATTACK_POSITION_PROBABILITIES: Array[int] = [13,13,13,14,14,11,11,12];
const POSITION_CONVERSION: Dictionary = {
	0: "GK",
	1: "LWB",
	2: "LB",
	3: "CB",
	4: "RB",
	5: "RWB",
	6: "LM",
	7: "CM",
	8: "CDM",
	9: "CAM",
	10: "RM",
	11: "LW",
	12: "CF",
	13: "ST",
	14: "RW" };


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
# Territory cache
var Territory_Cache: Dictionary

# Team Cache
var Team_Cache: Dictionary 


# Cache For Names
var First_Name_Cache: Dictionary 
var Last_Name_Cache: Dictionary 








func _init(gm: GameMap):
	# Here we want to create a cache for all the information we will want to get later. This is in order to speed up the player creation later
	
	# Here we iter through all territories
	for terr in gm.Territories:
		# Here we set up the Territory Cachce
		Territory_Cache[terr.Territory_ID] = terr;
		
		# Now we get the names for each Territory
		var first_names := Array(terr.First_Names).map(func(name_id: int): return gm.get_name_by_id(name_id));
		var last_names := Array(terr.Last_Names).map(func(name_id: int): return gm.get_name_by_id(name_id));
		First_Name_Cache[terr.Territory_ID] = first_names;
		Last_Name_Cache[terr.Territory_ID] = last_names;
		
	# Here we set up the Team Cache
	for team in gm.Teams:
		Team_Cache[team.ID] = team;
		
	# Now we set the game_map memeber
	game_map = gm;
		
	





## This function will create the entire roster for a team if given a team id
func generate_team_roster(team_id: int, percent_local:= -1, percent_foreign := -1) -> Array[Player]:
	# First we need to get the team information
	var team: Team = game_map.get_team_by_id(team_id);
	
	# Now we want to get the team rating and territory
	var team_rating: int = team.Rating;
	var team_terr: Territory = game_map.get_territory_by_id(team.Territory_ID);
	
	# Now we have to consider if both num_local and num_foreign are both -1. In this case we take an estimation 
	# to how many are local and how many are foreign
	if percent_local == -1 && percent_foreign == -1:
		percent_foreign = roundi(66 * (team_rating / 85));
		percent_local = 100 - percent_foreign;
		
	# Calculate the number of local and foreign based on percentages passed in or estimated
	var num_local: int = roundi(STARTING_TEAM_PLAYER_NUMBER * (percent_local / 100.0))
	var num_foreign: int = STARTING_TEAM_PLAYER_NUMBER - num_local;
	
	# Now we simply call the create player function with the number of local and number of foreign
	var player_roster: Array[Player] = [];
	player_roster.resize(STARTING_TEAM_PLAYER_NUMBER);
	
	for i in range(num_local):
		player_roster[i] = generate_player(STARTING_AGES.pick_random(), team_terr.Territory_ID, team_id);
		
	var foreign_territories: Array[int] = get_n_random_nationalities(team_terr.Territory_ID, num_foreign);
	for j in range(num_local, STARTING_TEAM_PLAYER_NUMBER):
		player_roster[j] = generate_player(STARTING_AGES.pick_random(), foreign_territories[j - num_local], team_id);
		
	# Finally just return player list
	return player_roster

## This function generates N number of players for the given territory.[br]NO CLUB TEAM data will be given and most then be allocated as desired to teams
func generate_players_from_territory(terr_id: int, n:= 1) -> Array[Player]:
	# Create array to store players
	var player_roster: Array[Player] = [];
	player_roster.resize(n);
	
	
	# Now we simply generate n number of players
	for i in range(n):
		player_roster[i] = generate_player(STARTING_AGES.pick_random(), terr_id)
	
	# Now just return
	return player_roster


	

## This function generates players for all the teams in the territory passed in
func generate_entire_territory_players(terr_id: int) -> Array[Player]:
	# First we need to get a list of all the teams in this territory
	
	
	
	
	return [];
	
	
	
func generate_entrie_database() -> Array[Player]:
	#Generate the array that will hold all players
	var player_list: Array[Player];
	#var player_list_sq: Array[Array[Player]];
	
	
	# Now we go through all Teams and generate players for them
	for team in game_map.Teams:
		player_list.append_array(generate_team_roster(team.ID));
	#var task_id = WorkerThreadPool.add_group_task(generate_team_roster, enemies.size())
	
	
	return player_list
	


## This function will create one player with the given paramaters.
func generate_player(age: int, terr_id := -1, team_id := -1) -> Player:
	# First create the instance of the player to be created
	var player: Player = Player.new();
	
	# Set player age
	player.set_player_age(age);
	

	# First we have to generate some random values
	var position_chance: int = randi() % 101; #get random integer between 0 and 100
	var foot_chance: int = randi() % 101;
	
	
	# Now we determine position, height, and weight
	# Here height and weight use a normal distribution using the const mean and std dev defined above
	if position_chance < 10:
		player.set_players_positions([0]);
		player.set_player_height(roundi(randfn(AVG_GK_HEIGHT, HEIGHT_STD_DEV)));
		player.set_player_weight(roundi(randfn(AVG_GK_WEIGHT, WEIGHT_STD_DEV)));
	elif position_chance < 40:
		player.set_players_positions([DEFENSE_POSITION_PROBABILITIES.pick_random()]);
		player.set_player_height(roundi(randfn(AVG_DEF_HEIGHT, HEIGHT_STD_DEV)));
		player.set_player_weight(roundi(randfn(AVG_DEF_WEIGHT, WEIGHT_STD_DEV)));
	elif position_chance < 70:
		player.set_players_positions([MIDFIELD_POSITION_PROBABILITIES.pick_random()]);
		player.set_player_height(roundi(randfn(AVG_MID_HEIGHT, HEIGHT_STD_DEV)));
		player.set_player_weight(roundi(randfn(AVG_MID_WEIGHT, WEIGHT_STD_DEV)));
	else:
		player.set_players_positions([ATTACK_POSITION_PROBABILITIES.pick_random()]);
		player.set_player_height(roundi(randfn(AVG_ATT_HEIGHT, HEIGHT_STD_DEV)));
		player.set_player_weight(roundi(randfn(AVG_ATT_WEIGHT, WEIGHT_STD_DEV)));

	# Now we determine whether the player is left or right footed
	if foot_chance < 15:
		player.set_player_foot(false);
	else:
		player.set_player_foot(true);

	# Now we need to determine the player's rating. We do this by using the player's nationality
	# and their team's average rating 
	
	var player_terr : Territory;
	var potential: float;
	
	
	# If Terr_ID is left empty, we will randomly choose a territory for the player
	if terr_id == -1:
		var territory_ids:  Array[int] = Territory_Cache.keys();
		terr_id = territory_ids.pick_random();
		
		
		
		
	if team_id == -1: # No team was given so just use Territory Rating as average rating 
		# Set Nationality of Player
		player.add_player_nationality(terr_id);
		player_terr = Territory_Cache[terr_id];
		
		# Determine potential and ensure its withtin the range of 10 - 94
		potential = randfn(66, TERRITORY_STD_DEV);
		while potential > 94 || potential < 10:
			potential = randfn(player_terr.Rating, TERRITORY_STD_DEV);
			
	else: # Team is given so use that and Territory Rating to determine mean potential for player
		# Set Nationality AND Team of Player
		player.add_player_nationality(terr_id);
		player.set_player_club_team(team_id);
		
		var player_team: Team = Team_Cache[team_id]
		player_terr = Territory_Cache[terr_id];
		
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
	var first_name_list = First_Name_Cache[terr_id];
	var last_name_list = Last_Name_Cache[terr_id];
	var middle_chance: int = randi() % 101;
	var first_name: String = "e"
	var middle_name: String = "e"
	var last_name: String = "e"
	while first_name == last_name || middle_name == last_name || middle_name == first_name:
		first_name = first_name_list.pick_random();
		last_name = last_name_list.pick_random();
		middle_name = last_name_list.pick_random();
			
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
func get_n_random_nationalities(terr_id: int, n: int) -> Array[int]:
	# First we simply need to get the territory passed in
	var terr: Territory = game_map.get_territory_by_id(terr_id);
	
	# Now, we need to get the league elo ratings for all territories in the game
	var terr_ids: Array = game_map.Territories.filter(func(terr: Territory): return terr.Territory_ID != terr_id).map(func(terr: Territory): return terr.Territory_ID);
	var terr_league_elos: Array = game_map.Territories.filter(func(terr: Territory): return terr.Territory_ID != terr_id).map(func(terr: Territory): return terr.League_Elo);
	
	
	# Now we adjust the weights
	# 1. If a country has a higher elo than our country, we decrease their odds by 70%
	# 2. For countries with zero league elo, we make it 10 since they can be in any league
	terr_league_elos.map(func(elo: int): if elo > terr.League_Elo: return elo * 0.3 elif elo < 1: return 10.0 else: return elo);
	
	
	# Now we need to do the weighted probabilities array
	var weights_acc: Array[float] = [];
	weights_acc.resize(terr_league_elos.size());
	var weights_sum := 0.0
	for i in weights_acc.size():
		weights_sum += terr_league_elos[i]
		weights_acc[i] = weights_sum
	
	
	
	# Finally, we get n random nationalities
	var random_nationalities: Array[int];
	for i in range(n):
		var weight_threshold := randf_range(0.0, weights_acc.back());
		var index: int = weights_acc.bsearch(weight_threshold);
		random_nationalities.push_back(terr_ids[index]);
	return random_nationalities;
	
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

	
	
""" The following Functions are used to print the information in a Player instance """
func print_player(p: Player) -> void:
	var player_name: String = p.Name;
	var player_age: String = String.num_int64(p.get_player_age());
	var player_overall: String = String.num_int64(p.get_player_overall_rating());
	var player_potential: String = String.num_int64(p.get_player_potential_rating());
	var player_nationality: String = game_map.get_territory_by_id(p.get_player_nationalities()[0]).Territory_Name;
	var player_position: String = POSITION_CONVERSION[p.get_player_positions()];
	var player_height: String = String.num_int64(p.get_player_height());
	var player_weight: String = String.num_int64(p.get_player_weight());
	var player_skill_stars: String = "*".repeat(p.get_player_skill_moves());
	var player_weak_foot: String = "*".repeat(p.get_player_weak_foot());
	var player_team: String = game_map.get_team_by_id(p.get_player_club_team()).Name
	print(player_name + " " + player_age + " " + player_nationality + " " + player_height + " " + player_weight)
	print(player_team + " " + player_position + " " + player_overall + " " + player_potential + " " + player_skill_stars + " " + player_weak_foot)
	
	

