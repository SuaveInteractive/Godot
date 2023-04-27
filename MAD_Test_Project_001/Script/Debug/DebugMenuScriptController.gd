extends Node2D 

var debugScriptController = load("res://Script/Debug/DebugScriptController.tscn")

var checkbutton : CheckButton = null

var runner = null
var recorder = null

func _init(scriptRunner, scriptRecorder):
	self.name = "Debug Show Script Controller"
	runner = scriptRunner
	recorder = scriptRecorder
		
func _ready():
	pass

func getGUIControl():
	checkbutton = CheckButton.new()
	checkbutton.name = "Show Script Controller"
	checkbutton.text = "Show Script Controller"	
	
	var _ret = checkbutton.connect("toggled", self, "OnButtonToggle")
	
	return checkbutton;
	
func OnButtonToggle(toggle):
	if toggle:
		var debugScriptControllerInstance = debugScriptController.instance()
		debugScriptControllerInstance.setRunner(runner)
		debugScriptControllerInstance.setRecorder(recorder)
		debugScriptControllerInstance.margin_left = checkbutton.get_size().x
		add_child(debugScriptControllerInstance)
	
		debugScriptControllerInstance.connect("WindowClosed", self, "OnWindowClosed")
	elif get_child(0):
		get_child(0).queue_free()

func OnWindowClosed():
	checkbutton.pressed = false
