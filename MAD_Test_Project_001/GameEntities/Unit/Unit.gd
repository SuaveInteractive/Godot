extends Node2D

func _ready():
	pass
	
func getRect() -> Rect2:
	var size = $EntityObfuscation.getSize()
	
	size.x = size.x * scale.x
	size.y = size.y * scale.y
	
	var rect = Rect2(position, size)
	return rect
