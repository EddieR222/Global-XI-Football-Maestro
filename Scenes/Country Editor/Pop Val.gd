extends SpinBox




func territory_selected(t: Territory):
	var pop: float = t.Population / 1_000_000
	get_line_edit().text = str(pop).pad_decimals(2) + " Million"
	
