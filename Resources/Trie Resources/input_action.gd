class_name InputAction
extends Resource

enum INPUTTYPE {
	PRESS, 
	HOLD,
	DIRECTION,
	RELEASE,
};
@export var event: InputEvent
@export var action: String
@export var type: INPUTTYPE
@export var time_pressed: float
