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
#
#		# draw the path
#		line_2d.clear_points()
#		line_2d.add_point(submarine.global_position)
#		for i in range(path.size()):
#			line_2d.add_point(path[i])

func _on_Submarine_clicked(node):
	return
	selectedNode = node 
	selectedNode.get_node("Selected").visible = true
	self.visible = true
	self.set_process_unhandled_input(true)
