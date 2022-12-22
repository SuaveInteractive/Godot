extends "res://GameCommand/GameCommand.gd"

var TargetorIDs : Array
var Target_Position : Vector2
var WorldController : Node

func _ready():
	Command_Name = "Target_Command"
	
func execute() -> bool:
	if TargetorIDs.empty():
		return false
	
	for targetorID in TargetorIDs:
		WorldController.addTarget(targetorID, Target_Position)
		
	return false
