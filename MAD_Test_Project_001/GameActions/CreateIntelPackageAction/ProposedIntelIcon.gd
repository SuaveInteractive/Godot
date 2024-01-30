extends TextureRect

signal DragStart()

func get_drag_data(_position):
	emit_signal("DragStart")
	
	var textureRec = TextureRect.new()
	textureRec.texture = texture
	set_drag_preview(textureRec)

	var dragData = {"Texture": texture}
	return dragData

