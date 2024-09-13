extends SpinBox


func territory_selected(t: Territory):
	get_line_edit().text = str(t.CoTerritory_ID);
	#print("Previous Value: " + str(t.CoTerritory_ID));

