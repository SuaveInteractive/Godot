extends Node2D 

var debugDetectorScene = load("res://DetectorRendering/Debug/DebugDetectorInformation.tscn")

var checkbutton : CheckButton = null
var DetetorTexture : Texture = null

func _init(detectionTexture : Node = null):
	DetetorTexture = detectionTexture.get_texture()
	self.name = "Debug Show Detector Texture"
		
func _ready():
	pass

func getGUIControl():
	checkbutton = CheckButton.new()
	checkbutton.name = "Show Detector"
	checkbutton.text = "Show Detector Texture"	
	
	var _ret = checkbutton.connect("toggled", self, "OnButtonToggle")
	
	return checkbutton;
	
func OnButtonToggle(toggle):
	if toggle:
		var debugDetectorSceneInsatnce = debugDetectorScene.instance()
		debugDetectorSceneInsatnce.SetTexture(DetetorTexture)
		add_child(debugDetectorSceneInsatnce)
	
		debugDetectorSceneInsatnce.connect("WindowClosed", self, "OnWindowClosed")
	elif get_child(0):
		get_child(0).queue_free()

func OnWindowClosed():
	checkbutton.pressed = false
