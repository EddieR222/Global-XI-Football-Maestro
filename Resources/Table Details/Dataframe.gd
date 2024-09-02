class_name Dataframe 
extends Resource

""" The data """
## The Title names for the Itemlist
@export var title_names: Array[String];

## The rows of the Table 
@export var data: Array;

## The column that will contain metadata
@export var metadata_column: String;

## The function called to get the text and icon from the data structure in data array
@export var get_text_and_icon: Callable;


func _init(_data: Array, _titles: Array[String], _metadata_col: String,  _get_text_and_icon: Callable):
	data = _data;
	get_text_and_icon = _get_text_and_icon
	metadata_column = _metadata_col;
	title_names = _titles;
	


