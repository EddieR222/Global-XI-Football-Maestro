class_name ResourceImageManager
extends Resource
## A simple Image Manager that can take in one image and ensure 
## it is saved and loaded correctly
##
## 

signal image_changed

@export var height: int;
@export var width: int;

var _file_directory: String;
var _file_name: String;
var _default_image: String;

func _init(dir: String, _height: int, _width: int):
	_file_directory = dir;
	height = _height;
	width = _width;

## Saves the passed in image and file_name. If no file_name is passed in, this will use the uuid as a file_name.
## Will delete a previously saved image if any.[br]
## Returns errors if any or okay
func save_image(img: Image, file_name := "") -> Error:
	var error: Error;
	
	# First, ensure image data is valid
	if img == null:
		return ERR_INVALID_DATA
	
	# Second, if image already saved, we need to delete the previous version
	if _file_name != null and not _file_name.is_empty():
		error = DirAccess.remove_absolute(_file_directory + _file_name)
		if error:
			return error;
		image_changed.emit() # ONLY gets emitted when image is changed
			
	# Now we need to resize the image
	img.resize(width, height, 2);
	
	# Now we need to save this image (possibly using uuid)
	file_name = uuid.v4() + ".png" if file_name.is_empty() else file_name + ".png"
	error = img.save_png(_file_directory + file_name);
	if error:
		return error
	
	# Now we save the file_name
	_file_name = file_name;
	return OK;
	
## Loads and returns the previously saved image. If there is no image saved, it will return the default image. If both image and default aren't viable then this will return null.
func load_image() -> Image:
	var error: Error;
	var image: Image
	
	# First, we check if image even exists, if it does simply return it
	if not _file_name.is_empty() and FileAccess.file_exists(_file_directory + _file_name):
		image = Image.load_from_file(_file_directory + _file_name);
		if image != null:
			return image
	
	# Second, we try loading default image
	if not _default_image.is_empty() and FileAccess.file_exists(_file_directory + _default_image):
		image = Image.load_from_file(_file_directory + _default_image);
		if image != null:
			return image 
	
	# Finally, both image and default are viable so we simply return null
	return null

## Saves the passed in image as the default image. 
## Automatically uses uuid as a file_name to ensure no collisions with any file_name passed for other images
## Will delete a previously saved default image if any.[br]
## Returns errors or okay
func set_default_image(img: Image) -> Error:
	var error: Error;
	
	# First, ensure image data is valid
	if img == null:
		return ERR_INVALID_DATA
	
	# Second, if image already saved, we need to delete the previous version
	if _default_image != null and not _default_image.is_empty():
		error = DirAccess.remove_absolute(_file_directory + _default_image)
		if error:
			return error;
		image_changed.emit() # ONLY gets emitted when image is changed
			
	# Now we need to resize the image
	img.resize(width, height, 2);
	
	# Now we need to save this image (possibly using uuid)
	var file_name: String = uuid.v4() + ".png"
	error = img.save_png(_file_directory + file_name);
	if error:
		return error
	
	# Now we save the file_name
	_default_image = file_name;
	return OK;
	
