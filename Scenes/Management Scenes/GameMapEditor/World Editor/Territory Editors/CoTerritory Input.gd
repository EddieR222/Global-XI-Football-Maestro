extends OptionButton


func territory_selected(t: Territory):
	if t.CoTerritory != null:
		for index:int  in range(item_count):
			var _metadata: Territory = get_item_metadata(index);
			if _metadata == t.CoTerritory:
				select(index)
	else:
		select(0)
		
	
