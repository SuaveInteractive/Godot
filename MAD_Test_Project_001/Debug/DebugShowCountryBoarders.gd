extends Node2D 

var debugPolylineScript = load("res://Debug/DebugPolyline2D.gd")

func _ready():
	visible = false

func _init(countriesBoarders):
	for boarder in countriesBoarders:
		var debugPolyline = debugPolylineScript.new()
		var polyPoints = PoolVector2Array(boarder)
		polyPoints.append(boarder[0])
		debugPolyline.points = polyPoints
		add_child(debugPolyline)
	
	
