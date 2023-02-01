extends Sprite

export(Vector2) var Velocity = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + (Velocity * delta)

func _on_DetectNode_EnitityDetected(Entity):
	pass # Replace with function body.
