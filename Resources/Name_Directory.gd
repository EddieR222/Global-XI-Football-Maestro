class_name Name_Directory extends Resource

### 
@export var First_Names: Array[String]

###
@export var Last_Names: Array[String]


""" The following functions are for Adding/Removing Names """
### Add the name to the directory. Returns the name_id once the name is added
func add_name(name: String, first_name: bool) -> int:
	# First we need to ensure this name is valid. For this we basically just check that the length of it is greater than 1
	if name.length() < 2:
		return -1;
		
	# Now we have to do a binary search since after each insert the array is sorted.
	# If name is already present, we return 
	# Else, we add it so it maintains the array sorted
	var insertion_index : int;
	if (first_name):
		insertion_index = First_Names.bsearch(name, true)
		if (First_Names[insertion_index] == name):
			return -1;
		else:
			# Now we can add it in
			First_Names.append(name);
			First_Names.sort();
	else:
		insertion_index = Last_Names.bsearch(name, true)
		if (Last_Names[insertion_index] == name):
			return -1;
		else:
			# Now we can add it in
			Last_Names.append(name);
			Last_Names.sort();

	return insertion_index;
		
### Add the array of names to the directory
func add_names(new_names: Array[String], first_names: bool) -> Array[int]:
	var indexes: Array[int] = [];
	for name in new_names:
		var new_index: int = add_name(name, first_names);
		indexes.append(new_index);
		
	return indexes

### Removes a name given the string of the name. If name isn't present then nothing happens
func remove_name(name: String, first_name: bool) -> void:
	# First we need to ensure this name is valid. For this we basically just check that the length of it is greater than 1
	if name.length() < 2:
		return
		
	var deletion_index : int;
	if (first_name):
		deletion_index = First_Names.bsearch(name, true)
		if (First_Names[deletion_index] == name):
			# We ensured the name is actually present, so we remove it
			First_Names.remove_at(deletion_index);
	else:
		deletion_index = Last_Names.bsearch(name, true)
		if (Last_Names[deletion_index] == name):
			Last_Names.remove_at(deletion_index);

### Removes a name given its name_id. If Id is valid, it will remove regardless of what the string is so be careful
func remove_name_by_id(name_id: int, first_name: bool) -> void:
	
	if (first_name):
		if name_id >= 0 and name_id <= First_Names.size():
			# We ensured the name is actually present, so we remove it
			First_Names.remove_at(name_id);
	else:
		if name_id >= 0 and name_id <= Last_Names.size():
			Last_Names.remove_at(name_id);
			
	return

### Remove the array of name, If name isn't present then nothing happens
func remove_names(remove_names: Array[String], first_names: bool) -> void:
	for name in remove_names:
		remove_name(name, first_names)
		
### Remove the array of name_ids.
func remove_names_by_id(name_ids: Array[int], first_names: bool) -> void:
	for name in name_ids:
		remove_name_by_id(name, first_names);


"""Checking Memebership"""
### Function to check if name is in the entire directory
func name_in_directory(name: String) -> bool:
	if name.length() < 2:
		return false;
		
	if name_in_first_names(name) or name_in_last_names(name):
		return true
	else:
		return false

### Function to check if name is in the First Names list
func name_in_first_names(name: String) -> bool:
	# Verify valid length
	if name.length() < 2:
		return false;
		
	# Now get if in First Names
	var index: int = First_Names.bsearch(name, true);
	if (First_Names[index] == name):
		return true;
	else:
		return false;

### Function to check if name is in the Last Names List
func name_in_last_names(name: String) -> bool:
	# Verify valid length
	if name.length() < 2:
		return false;
		
	# Now get if in First Names
	var index: int = Last_Names.bsearch(name, true);
	
	if (Last_Names[index] == name):
		return true;
	else:
		return false;
		
func name_in_directory_by_id(name_id: int) -> bool:
	if name_id >= 0 and name_id < First_Names.size() + Last_Names.size():
		return true;
	else:
		return false;


""" Functions to get name(s) """
### Given the id of the name, this gets the name stored in the directory with that id
func get_name_by_id(name_id: int) -> String:
	if name_id >= 0 and name_id < First_Names.size():
		return First_Names[name_id];
	elif name_id >= First_Names.size() and name_id < First_Names.size() + Last_Names.size():
		return Last_Names[name_id - First_Names.size()];
	else:
		return "";
		
func get_first_names() -> Array[String]:
	return First_Names;
	
func get_last_names() -> Array[String]:
	return Last_Names;

func get_id_of_name(name: String, first_name: bool) -> int:
	if (first_name):
		var index: int = First_Names.find(name);
		return index;
	else:
		var index: int = Last_Names.find(name);
		if (index == -1):
			return index;
		else:
			return index + First_Names.size() + 1;

""" Sorting """

func sort_names() -> void:
	First_Names.sort();
	Last_Names.sort();

