extends ItemList


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
	


func _on_add_territory_pressed():
	var texture: CompressedTexture2D = load("res://Images/icon.svg");
	var index: int = $".".add_item("Territory", texture, true);



	
