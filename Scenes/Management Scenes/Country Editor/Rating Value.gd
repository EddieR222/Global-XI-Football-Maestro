extends SpinBox




func territory_selected(t: Territory):
	get_line_edit().text = str(t.Rating);
	
