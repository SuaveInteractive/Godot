extends Button

signal UIBuildStructure(buildInfo)

var BuildingFactory = null

func _init():
	BuildingFactory = load("res://GameEntities/Structure/StructureFactory.gd").new()
	add_child(BuildingFactory)

func _on_Build_toggled(button_pressed):
	$BuildButtonVBoxContainer.visible = button_pressed

func getStructureInfo(var buildingName):
	var ret = {}
	var structureInfo = BuildingFactory.getBuildingInformation(buildingName)
	ret["ConstructionCost"] = structureInfo.ContructionCost
	ret["ContructionTimeDays"] = structureInfo.ContructionTimeDays
	return ret
	
func _on_BuildSiloButton_pressed():
	var structureInfo = getStructureInfo("Silo")
	structureInfo.merge({"ActionName": "BuildAction", "BuildingName": "Silo", "Texture": "res://GameEntities/Structure/Silo/FullHealth.png", "Scale": Vector2(0.75, 0.75)})
	emit_signal("UIBuildStructure", structureInfo)

func _on_BuildRadarButton_pressed():
	var structureInfo = getStructureInfo("Radar")
	structureInfo.merge({"ActionName": "BuildAction", "BuildingName": "Radar", "Texture": "res://GameEntities/Structure/Radar/Construction.png", "Scale": Vector2(0.12, 0.12)})
	emit_signal("UIBuildStructure", structureInfo)
