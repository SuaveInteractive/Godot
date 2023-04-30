extends Node2D 

var debugScriptController = load("res://Script/Debug/DebugScriptController.tscn")

var checkbutton : CheckButton = null

var Runner = null
var Recorder = null

func _init(scriptRunner, scriptRecorder):
	self.name = "Debug Show Script Controller"
	Runner = scriptRunner
	Recorder = scriptRecorder
		
func _ready():
	if Settings.Get("RunScriptOnStartup") == true:
		var runnerScript = Settings.Get("RunnerScript")
		if runnerScript != null:
			var scriptResource = load(runnerScript)
			Runner.setScript(scriptResource)
			Runner.Run()

func getGUIControl():
	checkbutton = CheckButton.new()
	checkbutton.name = "Show Script Controller"
	checkbutton.text = "Show Script Controller"	
	
	var _ret = checkbutton.connect("toggled", self, "OnButtonToggle")
	
	return checkbutton;
	
func OnButtonToggle(toggle):
	if toggle:
		var debugScriptControllerInstance = debugScriptController.instance()
		debugScriptControllerInstance.setRunner(Runner)
		debugScriptControllerInstance.setRecorder(Recorder)
		debugScriptControllerInstance.margin_left = checkbutton.get_size().x
		add_child(debugScriptControllerInstance)
	
		debugScriptControllerInstance.connect("WindowClosed", self, "OnWindowClosed")
	elif get_child(0):
		get_child(0).queue_free()

func OnWindowClosed():
	checkbutton.pressed = false
