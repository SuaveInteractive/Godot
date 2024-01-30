extends Control

signal IntelAdded(screenPos, previewTexture, data)

func _ready():
	hide()

func can_drop_data(_position, _data):
	return true

func drop_data(position, data):
	var previewTexture : Texture = data.Texture
	emit_signal("IntelAdded", position, previewTexture, {"Type": "Radar"})
	hide()
	
#https://docs.godotengine.org/en/3.5/classes/class_control.html#class-control-method-set-drag-preview

func _on_TextureRect_DragStart():
	show()
