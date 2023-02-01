extends Node2D 

var debugPolylineScript = load("res://Debug/DebugPolyline2D.gd")

func _ready():
	pass

func _init(countriesBoarders):
	self.name = "Debug Show Country Boarders"
	
	for boarder in countriesBoarders:
		var debugPolyline = debugPolylineScript.new()
		var polyPoints = PoolVector2Array(boarder)
		polyPoints.append(boarder[0])
		debugPolyline.points = polyPoints
		debugPolyline.name = "CountryBoarder"
		debugPolyline.visible = false
		add_child(debugPolyline)
		
func getGUIControl():
	var checkbutton = CheckButton.new()
	checkbutton.name = "Show Boarders"
	checkbutton.text = "Show Boarders"	
	
	checkbutton.connect("toggled", self, "OnButtonToggle")
	
	return checkbutton;
	
func OnButtonToggle(toggle):
	for child in get_children():
		child.visible = toggle
	
