extends GutTest


class TestPlayerGeneration:
	extends GutTest
	
	var p: PlayerManager = null
	var gm_manager: GameMapManager = null;
	var gm: GameMap = null;

	func before_each():
		
		gm_manager = GameMapManager.new();
		gm = gm_manager.load_game_map_with_filename("csv_save");
		p = PlayerManager.new(gm);
		
	func test_single_player_generation():
		 # Start time
		var start_time = Time.get_ticks_usec();
		
		# Call the function you want to measure
		var player: Player = p.generate_player(22, 2, 6);
		
		# End time
		var end_time = Time.get_ticks_usec();
		
		# Calculate the duration
		var duration = end_time - start_time
		
		print("Function execution time: ", duration, " us")
		print("Function execution time: ", float(duration) / 1000000.0, "secs")
		p.print_player(player);
		assert_eq(player.get_player_nationalities()[0], 2, "Given a terr_id of 2, we should get a player with terr_id of 2")
		

	func test_team_roster_generation():
		# Start time
		var start_time = Time.get_ticks_usec();
		
		
		var players := p.generate_team_roster(9487, 60, 40);
		
		
		# End time
		var end_time = Time.get_ticks_usec();
		
		# Calculate the duration
		var duration = end_time - start_time
		
		print("Function execution time: ", duration, " us")
		print("Function execution time: ", float(duration) / 1000000.0, "secs")
		
		
		for player in players:
			p.print_player(player)
			assert_eq(player.get_player_nationalities()[0], 2, "Given a terr_id of 2, we should get a player with terr_id of 2")	
			
			
	func test_territory_player_generation():
		# Start time
		var start_time = Time.get_ticks_usec();
		
		
		var players := p.generate_players_from_territory(144, 1000000);
		
		# End time
		var end_time = Time.get_ticks_usec();
		
		# Calculate the duration
		var duration = end_time - start_time
		
		print("Function execution time: ", duration, " us")
		print("Function execution time: ", float(duration) / 1000000.0, "secs")
		
		#
		#for player in players:
			#p.print_player(player);
		
	func test_generating_entire_database():
		# Start time
		var start_time = Time.get_ticks_usec();
		
		
		var players := p.generate_entrie_database();
		
		# End time
		var end_time = Time.get_ticks_usec();
		
		# Calculate the duration
		var duration = end_time - start_time
		
		print("Function execution time: ", duration, " us")
		print("Function execution time: ", float(duration) / 1000000.0, "secs")


	func test_print_forgien_nation_weights():
		p.print_foreign_nations_weights();
		
		
	func test_player_mem():
		var pl: Player_List = Player_List.new()
		pl.Players = p.generate_players_from_territory(1, 100000);
		pl.seconds = pl.Players;
		pl.thirds = pl.Players;
		
		
		ResourceSaver.save(pl, "user://save_files/players.res", 32);
		
		
	func test_player_mem_works():
		var players: Player_List = ResourceLoader.load("user://save_files/players.res") as Player_List;
		for player in players.Players:
			var ob: Player = player.get_ref();
			print(ob.Name);
			
		
		
		
	func test_player_num_mem():
		var pl: Player_IDs = Player_IDs.new()
		var arr: Array[Player] = p.generate_players_from_territory(1, 1000)
		var pl_ids: Array[int];
		for num in arr:
			pl_ids.append(num.ID);
			
		print(pl_ids.size())
		pl.Players = pl_ids
		ResourceSaver.save(pl, "user://save_files/players.res");

			
			
#class TestGettingRandomNations:
	#extends GutTest
	#
	#
	#var p: PlayerManager = null
	#var gm_manager: GameMapManager = null;
	#var gm: GameMap = null;
#
	#func before_each():
		#p = PlayerManager.new();
		#gm_manager = GameMapManager.new();
		#gm = gm_manager.load_game_map_with_filename("selected_game_map");
		#p.game_map = gm;
		#
		#
		#
		#
		#
	#func test_terr_exclusion():
		#var random_nations: Array[int] = p.get_n_random_nationalities(1, 10);
		#var terr_initial: Territory = gm.get_territory_by_id(1)
		#print("Initial: " + terr_initial.Territory_Name);
		#
		#assert_does_not_have(random_nations, 1, "Function 'get_n_random_nationalities' failed to prevent the passed in territory from appearing in it's chosen list of random territories");
		#
		#var countries: Dictionary = {};
		#for id in random_nations:
			#var terr: Territory = gm.get_territory_by_id(id);
			#if countries.has(terr.Territory_Name):
				#countries[terr.Territory_Name] += 1;
			#else:
				#countries[terr.Territory_Name] = 1;
				#
		#print(countries)
		#
		
class TestLoadingCSV:
	extends GutTest
	
	
	var p: PlayerManager = null
	var gm_manager: GameMapManager = null;
	var gm: GameMap = null;


	func test_load_csv():
		gm_manager = GameMapManager.new();
		var gm: GameMap = gm_manager.get_csv_data();
		p = PlayerManager.new(gm);
		gm_manager.save_game_map(gm, "csv_save");
		
