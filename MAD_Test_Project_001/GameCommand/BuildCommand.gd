extends "res://GameCommand/GameCommand.gd"

var Position_Build : Vector2
var Build_Country : Node = null
var Build_Info = null

func _ready():
	Command_Name = "Build_Command"

func execute() -> bool:
	if Build_Info == null:
		return false
	
	var worldController = Build_Info.WorldController
	worldController.addBuilding("silo", Position_Build, "Country_1")
	
	#var siloInstance = siloScene.instance()
	#siloInstance.position = Position_Build
	
	# Remove cost from the country
	Build_Info.BuildCountry.reduceFinance(100)
		
	return true
