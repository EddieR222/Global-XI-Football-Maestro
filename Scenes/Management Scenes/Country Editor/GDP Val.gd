extends SpinBox



func territory_selected(t: Territory):
	var gdp: float = t.GDP / 1_000_000
	get_line_edit().text = str(gdp).pad_decimals(2) + " Million"
	
