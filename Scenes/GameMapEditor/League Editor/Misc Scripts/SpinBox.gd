extends SpinBox


func league_selected(t: Tournament) -> void:
	get_line_edit().text = str(t.Importance);

func clear_selection() -> void:
	get_line_edit().text = str(0);

