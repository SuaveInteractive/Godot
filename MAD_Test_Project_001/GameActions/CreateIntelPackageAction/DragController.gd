extends Control

signal IntelAdded(screenPos, type)

func _ready():
	pass

func can_drop_data(_position, _data):
	return true

func drop_data(position, data):
	var previewTexture : Texture = data.Texture
	emit_signal("IntelAdded", position, previewTexture)

#https://docs.godotengine.org/en/3.5/classes/class_control.html#class-control-method-set-drag-preview
