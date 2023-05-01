extends Control

signal WindowClosed()

export var SavePosition : bool = true
export (Resource) var Settings
export var WindowName : String setget setWindowName

var drag_position = null
var resourcePath : String = "user://DebugPersistentData.tres"

func _ready():
	if ResourceLoader.exists(resourcePath):
		Settings = ResourceLoader.load(resourcePath)
	else:
		Settings = load("res://Debug/DebugWindow/DebugWindowSettings.gd").new()
	rect_global_position = Settings.SavedPos

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
		
	Settings.SavedPos = rect_global_position
	
func _on_Button_pressed():
	var err = ResourceSaver.save(resourcePath, Settings)
	if err:
		var stringError : String = "[DebugControlWindow Scene]: Error occured trying to save Persistent Debug Data.  Error [" + err + "]"
		push_error(stringError)
	hide()
	queue_free()
	emit_signal("WindowClosed")
