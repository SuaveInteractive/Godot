extends Control

export var UnselectedColor : Color = Color.red
export var SelectedColor : Color = Color.green

var FocusedNode : Node = null setget setFocus, getFocus

func _ready():
	pass
	
func _process(_delta):
	_updateFocusPosition()
	
func setFocus(var focusNode : Node2D):
	FocusedNode = focusNode
	
	if FocusedNode is Sprite:
		$IntelTexture.texture = FocusedNode.texture
		set_size($IntelTexture.texture.get_size())
	
func getFocus() -> Node:
	return FocusedNode
	
func isSelected() -> bool:
	return $HBoxContainer/AddRemove.text == "Remove"
	
func setSelected(var selected : bool):
	_on_AddRemove_toggled(selected)
	
func _updateFocusPosition() -> void:
	var rect : Rect2
	if FocusedNode.has_method("getRect"):
		rect = FocusedNode.getRect()		
		set_size(rect.end - rect.position)
		set_position(rect.position - rect_size / 2) 
	else:
		set_position(FocusedNode.position)

"""
	Callbacks
"""
func _on_AddRemove_toggled(button_pressed):
	$HBoxContainer/AddRemove.pressed = button_pressed
	if button_pressed:
		$HBoxContainer/AddRemove.text = "Remove"
		$NinePatchRect.modulate = SelectedColor
	else:
		$HBoxContainer/AddRemove.text = "Add"	
		$NinePatchRect.modulate = UnselectedColor
