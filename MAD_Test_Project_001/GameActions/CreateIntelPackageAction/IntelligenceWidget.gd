extends Control

var FocusedNode : Node = null

func _ready():
	pass
	
func _process(delta):
	_updateFocusPosition()
	
func setFocus(var focusNode : Node2D):
	FocusedNode = focusNode
	
func _updateFocusPosition() -> void:
	var rect : Rect2
	if FocusedNode.has_method("getRect"):
		rect = FocusedNode.getRect()		
		set_size(rect.end - rect.position)
		set_position(rect.position - rect_size / 2) 
	else:
		set_position(FocusedNode.position)
		
