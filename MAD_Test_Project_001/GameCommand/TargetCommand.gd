extends "res://GameCommand/GameCommand.gd"

var SelectedUnits : Array = []
var Target_Position : Vector2
var WorldController : Node = null

func _ready():
	SetName("Target_Command")
	
func execution() -> bool:
	if SelectedUnits.empty():
		return false
	
	for selectedUnit in SelectedUnits:
		WorldController.addTarget(selectedUnit, Target_Position)
		
	return true
