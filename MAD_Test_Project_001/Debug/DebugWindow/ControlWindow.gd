extends Control

signal WindowClosed()

var drag_position = null

func _ready():
	pass

func setWindowName(var name : String) -> void:
	$TitleBar/WindowNameLabel.text = name

func _on_Window_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			drag_position = get_global_mouse_position() - rect_global_position
		else:
			drag_position = null
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position


func _on_Button_pressed():
	hide()
	queue_free()
	emit_signal("WindowClosed")
