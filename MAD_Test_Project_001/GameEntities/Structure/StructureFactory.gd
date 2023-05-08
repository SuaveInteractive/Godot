extends Node

var cityScene = preload("res://GameEntities/City/City.tscn")
var siloScene = preload("res://GameEntities/Structure/Silo/Silo.tscn")
var radarScene = preload("res://GameEntities/Structure/Radar/Radar.tscn")

func _ready():
	pass

func getBuildingInstance(var buildingName):
	var buildingInst = null
	match buildingName:
		"City":
			buildingInst = cityScene.instance()
		"Silo":
			buildingInst = siloScene.instance()
		"Radar":
			buildingInst = radarScene.instance()
	return buildingInst
