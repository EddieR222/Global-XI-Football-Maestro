extends GutTest


class TestKeyDetails:
	extends GutTest
	
	var player = load("res://Resources/Player Details/Player.gd")
	var p: Player = null

	func before_each():
		p = player.new()

	func test_height_set():
		p.set_player_height(1);
		
		## Setting the Height Bits only, we can check if it did it correctly
		## Setting 1 makes Key Details 256
		assert_eq(p.Key_Details, 256, 'Setter Function (setting height to 1) should make Key Details 256 (...0000100000000 = 256)')

	func test_weight_set():
		p.set_player_weight(1);
		
		## Setting the Height Bits only, we can check if it did it correctly
		## Setting 1 makes Key Details 65536
		assert_eq(p.Key_Details, 65536, 'Setter Function (setting weight to 1) should make Key Details 256 (...0000100000000... = 65536)')

	func test_no_overwrite():
		# If the functions work correctly, setting height and weight should't overwrite each other and both should still exist
		p.set_player_weight(1);
		p.set_player_height(1);
		
		assert_eq(p.Key_Details, 65792, "Setting Weight and Height as both 1 should equal 65792")
		
		
	func test_height_get():
		# First we set it
		p.set_player_height(1);
		
		
		# Now we make sure we get the right value back
		assert_eq(p.get_player_height(), 1, "Getter should get what we set for height (1)");
		
		
	func test_birth_month_setters():
		# First we set all values we can with 1, then we should ensure the right bits are set
		p.set_player_birthdate(2, 15, 2002);
		
		assert_eq(p.get_player_birth_month(), 2, "Getter should return 2 as Birth Month")

	func test_birth_day_setters():
		# First we set all values we can with 1, then we should ensure the right bits are set
		p.set_player_birthdate(2, 15, 2002);
		
		assert_eq(p.get_player_birth_day(), 15, "Getter should return 15 as Birth Day")
		
	func test_birth_year_setters():
		p.set_player_birthdate(2, 15, 2002);
		
		assert_eq(p.get_player_birth_year(), 2002, "Getter should return 2002 as Birth Year")


class TestTeamIDs:
	extends GutTest
	
	var player = load("res://Resources/Player Details/Player.gd")
	var p: Player = null

	func before_each():
		p = player.new()
		
		
	func test_club_team_setter():
		p.set_player_club_team(1);
		
		assert_eq(p.Team_IDs, 1, "Setting Club Team should make Team_IDs in player equal to 1");
		
	func test_national_team_setter():
		p.set_player_national_team(1);
		
		assert_eq(p.Team_IDs, 4294967296, "Setting National Team should make Team_IDs in player equal tp 4294967296");
		
	func test_club_team_getter():
		p.set_player_club_team(1);
		
		assert_eq(p.get_player_club_team(), 1, "Getter should get set value of 1");
		
	func test_national_team_getter():
		p.set_player_national_team(1);
		
		assert_eq(p.get_player_national_team(), 1, "Getter should get set value of 1");
