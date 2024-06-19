extends GutTest
## This file has some unit test for the functions inside of GameMap Script

class TestTerritoryAdditionandSort:
	extends GutTest
	
	var edit: GameMap = null;
	
	func before_each():
		edit = GameMap.new();
		
		# Create some basic territories to test adding and sorting
		var terr_a: Territory = Territory.new();
		terr_a.Territory_Name = "A";
		var terr_b: Territory = Territory.new();
		terr_b.Territory_Name = "B";
		var terr_d: Territory = Territory.new();
		terr_d.Territory_Name = "D";
		
		edit.add_territory(terr_a);
		edit.add_territory(terr_b);
		edit.add_territory(terr_d);
		
		
	func test_filter_keeps_sorted():
		var arr = [1,2,3,4,5,6];
		
		# Now we filter
		arr = arr.filter(func(num: int): return num != 3)
		
		# Assert
		assert_eq(arr, [1,2,4,5,6], "Filter didn't maintain order")

	func test_territories_sorted_correctly():
		# If we add a territory with name "Z", the order of the territories should be A - B - D - Z after adding (since it automatically sorts)
		
		#First create new territory
		var terr_z: Territory = Territory.new();
		terr_z.Territory_Name = "Z"
		
		# Now add it to GameMap
		edit.add_territory(terr_z);
		
		# Now ensure the territoryies are in order
		var terr: Territory = edit.Territories[0];
		assert_eq(terr.Territory_Name, "A", "GameMap Does Not Sort Correctly. First territory should be 'A'")
		
		terr =  edit.Territories[1];
		assert_eq(terr.Territory_Name, "B", "GameMap Does Not Sort Correctly. Second territory should be 'B'")
		
		terr =  edit.Territories[2];
		assert_eq(terr.Territory_Name, "D", "GameMap Does Not Sort Correctly. Third territory should be 'D'")
		
		terr =  edit.Territories[3];
		assert_eq(terr.Territory_Name, "Z", "GameMap Does Not Sort Correctly. Fourth territory should be 'Z'")
	
		
		
		
		

class TestConfederationAdditionandSort:
	extends GutTest
	
	var edit: GameMap = null;
	
	func before_each():
		edit = GameMap.new();
		
		# Create some basic Confederations to test adding and sorting
		var confed_a: Confederation = Confederation.new();
		confed_a.Name = "A";
		var confed_b: Confederation = Confederation.new();
		confed_b.Name = "B";
		var confed_d: Confederation = Confederation.new();
		confed_d.Name = "D";
		
		edit.add_confederation(confed_a);
		edit.add_confederation(confed_b);
		edit.add_confederation(confed_d);
		
	func test_confederations_sorted_correctly():
		#First create new territory
		var confed_c: Confederation = Confederation.new();
		confed_c.Name = "C"
		
		# Now add it to GameMap
		edit.add_confederation(confed_c);
		
		# Now ensure the territoryies are in order
		var confed: Confederation =  edit.Confederations[0];
		assert_eq(confed.Name, "A", "GameMap Does Not Sort Correctly. First Confederation should be 'A'")
		
		confed = edit.Confederations[1];
		assert_eq(confed.Name, "B", "GameMap Does Not Sort Correctly. Second Confederation should be 'B'")
		
		confed = edit.Confederations[2];
		assert_eq(confed.Name, "C", "GameMap Does Not Sort Correctly. Third Confederation should be 'C'")
		
		confed = edit.Confederations[3];
		assert_eq(confed.Name, "D", "GameMap Does Not Sort Correctly. Fourth Confederation should be 'D'")
		

		
class TestTeamAdditionandSort:
	extends GutTest

	var edit: GameMap = null;
