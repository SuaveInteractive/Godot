extends Node

var cityScene = preload("res://GameEntities/Structure/City/City.tscn")
var siloScene = preload("res://GameEntities/Structure/Silo/Silo.tscn")
var radarScene= preload("res://GameEntities/Structure/Radar/Radar.tscn")

var cityInformaiton : Resource
var siloInformaiton : Resource
var radarInformaiton : Resource

func _ready():
	cityInformaiton = _getStructureInfoFromScene("City")
	siloInformaiton = _getStructureInfoFromScene("Silo")
	radarInformaiton = _getStructureInfoFromScene("Radar")

func getBuildingInformation(var buildingName) -> Resource:
	var buildingInfo = null
	match buildingName:
		"City":
			buildingInfo = cityInformaiton
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
			buildingInst = siloScene.instance()
		"Radar":
			buildingInst = radarScene.instance()
	return buildingInst

func _getStructureInfoFromScene(var structName) -> Resource:
	var inst = getBuildingInstance(structName)
	var structInformaiton : Resource = inst.StructureInformation
	inst.queue_free()
	return structInformaiton
