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
	worldController.addBuilding(Build_Info.Building, Position_Build, Build_Info.BuildCountry.get_name())
	
	# Remove cost from the country
	Build_Info.BuildCountry.reduceFinance(100)
		
	return true
