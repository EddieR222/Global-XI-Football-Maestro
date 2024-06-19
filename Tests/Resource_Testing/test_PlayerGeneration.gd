extends GutTest


class TestPlayerGeneration:
	extends GutTest
	
	var p: PlayerManager = null
	var gm_manager: GameMapManager = null;
	var gm: GameMap = null;

	func before_each():
		p = PlayerManager.new();
		gm_manager = GameMapManager.new();
		gm = gm_manager.load_game_map_with_filename("selected_game_map");
		p.game_map = gm;
		
	func test_single_player_generation():
		
		var player: Player = p.generate_player(22, 2, 6);
		player.print_player();
		assert_eq(player.get_player_nationalities()[0], 2, "Given a terr_id of 2, we should get a player with terr_id of 2")
		

	func test_team_roster_generation():
		var players := p.generate_team_roster(6, 60, 40);
		for player in players:
			p.print_player(player)
			assert_eq(player.get_player_nationalities()[0], 2, "Given a terr_id of 2, we should get a player with terr_id of 2")	
			
			
	func test_mexico_players():
		var players := p.generate_territory_players(143, 10000);
		for player in players:
			p.print_player(player);
			
			
class TestGettingRandomNations:
	extends GutTest
	
	
	var p: PlayerManager = null
	var gm_manager: GameMapManager = null;
	var gm: GameMap = null;

	func before_each():
		p = PlayerManager.new();
		gm_manager = GameMapManager.new();
		gm = gm_manager.load_game_map_with_filename("selected_game_map");
		p.game_map = gm;
		
		
		
		
		
	func test_terr_exclusion():
		var random_nations: Array[int] = p.get_n_random_nationalities(1, 10);
		var terr_initial: Territory = gm.get_territory_by_id(1)
		print("Initial: " + terr_initial.Territory_Name);
		
		assert_does_not_have(random_nations, 1, "Function 'get_n_random_nationalities' failed to prevent the passed in territory from appearing in it's chosen list of random territories");
		
		var countries: Dictionary = {};
		for id in random_nations:
			var terr: Territory = gm.get_territory_by_id(id);
			if countries.has(terr.Territory_Name):
				countries[terr.Territory_Name] += 1;
			else:
				countries[terr.Territory_Name] = 1;
				
		print(countries)
