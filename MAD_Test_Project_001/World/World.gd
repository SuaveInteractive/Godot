extends Area2D

func _ready():
	pass
	
func _input_event(viewport, event, shape_idx):
	if not event is InputEventMouseButton:
		return
	if not Input.is_mouse_button_pressed(BUTTON_LEFT):
		return
		
	if event.button_index == BUTTON_LEFT:
		print ("World - _input_event")
		emit_signal("EntitySelected", self)
