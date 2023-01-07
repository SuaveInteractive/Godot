extends Area2D

export(Color) var drawColour = Color(1, 0, 1, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	for child in get_children():
		child.shape.draw(get_canvas_item(), drawColour)
	


