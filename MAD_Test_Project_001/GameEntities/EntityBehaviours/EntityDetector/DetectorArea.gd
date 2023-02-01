extends Area2D

export(Color) var drawColour = Color(1, 0, 1, 1)


# Called when the node enters the scene tree for the first time.
func _draw():
	#for child in get_children():
	#	child.shape.draw(get_canvas_item(), drawColour)
	pass
	
func _on_DetectorArea_area_entered(area):
	emit_signal("EnitityDetected", area)


func _on_DetectorArea_area_exited(_area):
	pass # Replace with function body.
