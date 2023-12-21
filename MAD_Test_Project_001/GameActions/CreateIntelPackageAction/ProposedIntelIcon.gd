extends TextureRect

func _ready():
	pass

func can_drop_data(position, data):
	return false

func drop_data(position, data):
	_handleData(data)

func get_drag_data(position):
	var textureRec = TextureRect.new()
	textureRec.texture = texture
	set_drag_preview(textureRec)

	var dragData = {}
	return dragData

func _handleData(var data):
	pass
