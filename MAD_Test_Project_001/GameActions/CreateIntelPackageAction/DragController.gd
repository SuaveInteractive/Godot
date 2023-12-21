extends Control

signal IntelAdded(screenPos, type)

func _ready():
	pass

func can_drop_data(position, data):
	return true

func drop_data(position, data):
	emit_signal("IntelAdded", position, "Radar")

#https://docs.godotengine.org/en/3.5/classes/class_control.html#class-control-method-set-drag-preview
