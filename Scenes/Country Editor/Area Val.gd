extends SpinBox




func territory_selected(t: Territory):
	var area: float = t.Area/ 1_000
	get_line_edit().text = str(area).pad_decimals(2) + " Thousand"
	
