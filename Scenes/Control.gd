extends Control

@onready var item_list: ItemList = get_node("VBoxContainer/ItemList");


func _on_add_pressed():
	#Create empty territory to add to itemlist
	var new_terr: Territory = Territory.new();
	new_terr.Territory_Name = "United States"
	var new_terr2: Territory = Territory.new();
	new_terr2.Territory_Name = "Mexico"
	var new_terr3: Territory = Territory.new();
	new_terr3.Territory_Name = "Canada"
	
	# Add to Itemlist
	var index: int = item_list.add_item(new_terr.Territory_Name, null, true);
	var index2: int = item_list.add_item(new_terr2.Territory_Name, null, true);
	var index3: int = item_list.add_item(new_terr3.Territory_Name, null, true);
	
	#Set Metadata
	item_list.set_item_metadata(index, new_terr);
	item_list.set_item_metadata(index2, new_terr2);
	item_list.set_item_metadata(index3, new_terr3);
	
	item_list.sort_items_by_text();
	


func _on_item_list_item_selected(index: int) -> void:

	#First we get the item from item_list
	var terr = item_list.get_meta_list();
	print(terr)
	
	for t in terr:
		print(t)
	
