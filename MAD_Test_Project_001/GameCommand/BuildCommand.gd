extends "res://GameCommand/GameCommand.gd"

var siloScene = load("res://GameEntities/Silo/Silo.tscn")

var Position_Build : Vector2
var Build_Country : Node = null
var Build_Info = null

func _ready():
	Command_Name = "Build_Command"

func execute() -> bool:
	if Build_Info == null:
		return false
	
	var siloInstance = siloScene.instance()
	siloInstance.position = Position_Build
	
	# Remove cost from the country
	Build_Info.BuildCountry.reduceFinance(siloInstance.getBaseConstructionCost())
	
	Build_Info.BuildCountry.add_child(siloInstance)
	
	return true
