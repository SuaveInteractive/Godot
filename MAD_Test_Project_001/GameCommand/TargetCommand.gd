extends "res://GameCommand/GameCommand.gd"

var Unit_Targeting : Array
var Target_Position : Vector2

func _ready():
	Command_Name = "Target_Command"
	
func execute() -> bool:
	if Unit_Targeting.empty():
		return false
	
	for unit in Unit_Targeting:
		unit.addTarget(Target_Position)
		
	return false
