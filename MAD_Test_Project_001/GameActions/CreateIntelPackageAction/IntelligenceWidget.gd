extends Control

var FocusedNode : Node = null

func _ready():
	pass
	
func setFocus(var focusNode : Node2D):
	FocusedNode = focusNode
	
	var rect : Rect2
	if focusNode.has_method("getRect"):
		rect = focusNode.getRect()		
		set_size(rect.end - rect.position)
		set_position(rect.position - rect_size / 2) 
	else:
		set_position(FocusedNode.position)
