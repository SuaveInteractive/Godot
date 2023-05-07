extends "res://GameCommand/GameCommand.gd"

var Position_Build : Vector2
var Build_Country : Node = null
var Build_Type_Str : String = ""
var WorldController : Node = null

func _ready():
	SetName("Build_Command")

func execution() -> bool:
	if Build_Country == null || WorldController == null || Build_Type_Str.empty():
		return false
	
	WorldController.addBuilding(Build_Type_Str, Position_Build, Build_Country.get_name())
	
	# Remove cost from the country
	Build_Country.reduceFinance(100)
		
	return true
