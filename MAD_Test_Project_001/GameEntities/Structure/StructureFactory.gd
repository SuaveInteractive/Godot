extends Node

var cityScene = preload("res://GameEntities/City/City.tscn")
var siloInformaiton = preload("res://GameEntities/Structure/Silo/SiloInformation.tres")
var radarInformaiton = preload("res://GameEntities/Structure/Radar/RadarInformation.tres")

func _ready():
	pass

func getBuildingInformation(var buildingName) -> Resource:
	var buildingInfo = null
	match buildingName:
		"City":
			pass
		"Silo":
			buildingInfo = siloInformaiton
		"Radar":
			buildingInfo = radarInformaiton
	return buildingInfo

func getBuildingInstance(var buildingName) -> Node:
	var buildingInst = null
	match buildingName:
		"City":
			buildingInst = cityScene.instance()
		"Silo":
			buildingInst = siloInformaiton.StructureScene.instance()
		"Radar":
			buildingInst = radarInformaiton.StructureScene.instance()
	return buildingInst
