extends Control

onready var nav_2d : Navigation2D = $"../World Map/Navigation2D"

onready var selectedNode 

func _ready():
	return
	self.set_process_unhandled_input(false)

func _unhandled_input(event : InputEvent) -> void:	
	return
	if not event is InputEventMouseButton:
		return
	if not Input.is_mouse_button_pressed(BUTTON_LEFT):
		return	
	
	if event.button_index == BUTTON_LEFT:
		var loc = event.get_global_position()
		var newPath = nav_2d.get_simple_path(selectedNode.global_position, loc)
		newPath.remove(0);
		
		selectedNode.path = newPath
