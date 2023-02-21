extends Sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update()

func _draw():
	var detectors = get_tree().get_nodes_in_group("Detectors")
	for dector in detectors:
		drawDetectionArea(dector.global_position, dector.DetectorArea)

func drawDetectionArea(position, detectorShapes):
	for shape in detectorShapes:
		if shape is CircleShape2D:
			shape = shape as CircleShape2D
			draw_circle (position, shape.radius, Color(0.0, 0.0, 0.0) )
