extends "res://GameCommand/GameCommand.gd"

var Units_Targeting : Array
var Target_Position : Vector2

func _ready():
	Command_Name = "Target_Command"
	
func execute() -> bool:
	if Units_Targeting.empty():
		return false
	
	for unit in Units_Targeting:
		unit.get_node("TargetNode").addTarget(Target_Position)
		
	return false
