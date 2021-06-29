extends Node

# Need to define this below signal 
#signal EntitySelected(entity)

var Selected : bool = false
var PlayerCountry : bool = false

func _ready():
	$SelectedSprite.visible = false

func _on_Selection_input_event(viewport, event, shape_idx):
	if not event is InputEventMouseButton:
		return
	if not Input.is_mouse_button_pressed(BUTTON_LEFT):
		return
	
	if event.button_index == BUTTON_LEFT:
		 Signals.emit_signal("EntitySelected", self)
		#Signals.emit_signal("UnitSetlected", self)
