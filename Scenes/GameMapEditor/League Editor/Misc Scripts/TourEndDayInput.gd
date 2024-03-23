extends OptionButton


var month_to_day: Dictionary = {1: 31, 2: 28, 3: 31, 4: 30, 5: 31, 6:30, 7: 31, 8: 31, 9: 30, 10: 31, 11:30, 12:31};

func tour_selected(t: Tournament) -> void:
	if t.End_Date.is_empty():
		return
		
	# Clear all days off
	clear();
	
	# Add all correct days for previous selected month
	for index: int in range(1, month_to_day[t.End_Date[0]] + 1):
		add_item(str(index))
	
	# Select the day previously saved
	select(t.End_Date[1] - 1)
		

func clear_selection() -> void:
	select(-1);
