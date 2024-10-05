class_name InputAction
extends Resource

enum INPUTTYPE {
	PRESS, 
	HOLD,
	DIRECTION,
	RELEASE,
};
@export var action: String
@export var type: INPUTTYPE


