extends "res://GameCommand/GameCommand.gd"

var SelectedUnits : Array = []
var Target_Position : Vector2
var WorldController : Node = null

func _ready():
	Command_Name = "Target_Command"
	
func execute() -> bool:
	if SelectedUnits.empty():
		return false
	
	for selectedUnit in SelectedUnits:
		WorldController.addTarget(selectedUnit, Target_Position)
		
	return false
