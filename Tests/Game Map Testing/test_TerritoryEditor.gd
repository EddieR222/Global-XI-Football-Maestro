extends GutTest
## This file has some unit test for the functions inside of Territory Editor Script

class TestUIInput:
	extends GutTest
	
	var terr_edit: PackedScene = preload("res://Scenes/GameMapEditor/World Editor/Territory Editors/Territory Editor.tscn");
	var edit: GraphNode = null;
	
	func before_each():
		edit = terr_edit.instantiate();
		
		edit.Territory = Territory.new();
		
	func test_name_edit_changed():
		
		edit._on_territory_name_edit_text_changed("Testing");
		
		assert_eq(edit.Territory.Name, "Testing", "Signal function should correctly set Name of Territory in Local Territory");
		
		
