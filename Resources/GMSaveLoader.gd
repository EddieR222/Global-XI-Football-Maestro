class_name GMSaveLoader extends Resource

## This function simply takes in a GameMap Resource and saves it.
## Images inside are compressed and the entire file is compressed too.
func save_game_map(game_map: GameMap, filename: String) -> void:
	# Given a game_map, we need to zip
	ResourceSaver.save(game_map, "user://{filename}.res".format({"filename": filename}), 32);
	
	write_to_zip(filename);


func write_to_zip(filename: String):
	var writer := ZIPPacker.new();
	var err := writer.open("user://archive.zip")
	if err != OK:
		return err
	writer.start_file("GameSavedData.txt")
	#Get Saved Game as Bytes
	var file_as_byte: PackedByteArray = FileAccess.get_file_as_bytes("user://{filename}.res".format({"filename": filename}))

	writer.write_file(file_as_byte)
	
	writer.close_file()
	return OK


func read_zip_file():
	var reader := ZIPReader.new()
	var err := reader.open("user://archive.zip")
	if err != OK:
		return PackedByteArray()
	var res := reader.read_file("GameSavedData.txt")
	reader.close()
	return res
