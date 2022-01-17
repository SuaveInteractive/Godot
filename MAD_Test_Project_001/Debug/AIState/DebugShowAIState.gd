extends Node2D 

var debugAIStateScene = load("res://Debug/AIState/DebugAIState.tscn")

var checkbutton : CheckButton = null

func _ready():
	pass

func _init(AIList):
	self.name = "Debug Show AI State"
			
func getGUIControl():
	checkbutton = CheckButton.new()
	checkbutton.name = "Toggle Show AI State"
	checkbutton.text = "Toggle Show AI State"	
	
	checkbutton.connect("toggled", self, "OnButtonToggle")
	
	return checkbutton;
	
func OnButtonToggle(toggle):
	if toggle:
		var debugAIStateInstance = debugAIStateScene.instance()
		add_child(debugAIStateInstance)
	
		debugAIStateInstance.connect("WindowClosed", self, "OnWindowClosed")
	elif get_child(0):
		get_child(0).queue_free()

func OnWindowClosed():
	checkbutton.pressed = false
