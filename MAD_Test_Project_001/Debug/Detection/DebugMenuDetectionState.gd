extends Node2D 

var debugDetectionState = load("res://Debug/Detection/DebugDetectionState.tscn")

var checkbutton : CheckButton = null

var DetectionProcessingNode = null

func _init():
	self.name = "Debug Show Entity Detection State"
			
func _ready():
	pass

func getGUIControl():
	checkbutton = CheckButton.new()
	checkbutton.name = "Show Entity Detection State"
	checkbutton.text = "Show Entity Detection State"	
	
	var _ret = checkbutton.connect("toggled", self, "OnButtonToggle")
	
	return checkbutton;
	
func OnButtonToggle(toggle):
	if toggle:
		var debugDetectionStateInstance = debugDetectionState.instance()
	
		debugDetectionStateInstance.setDetectionProcessor(DetectionProcessingNode)
		add_child(debugDetectionStateInstance)

		DetectionProcessingNode.connect("DetectTrackingChanged", debugDetectionStateInstance, "Refresh")
		debugDetectionStateInstance.connect("WindowClosed", self, "OnWindowClosed")
	elif get_child(0):
		get_child(0).queue_free()

func OnWindowClosed():
	checkbutton.pressed = false
	
func OnControllingCountryChanged(country):
	DetectionProcessingNode = country.get_node("DetectionProcessing")
