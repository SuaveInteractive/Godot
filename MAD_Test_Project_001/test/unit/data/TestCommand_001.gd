extends "res://GameCommand/GameCommand.gd"

var Position_To : Vector2
var Selected_Units : Array

func _init():
	SetName("Test_Command_001")

func execution() -> bool:
	if Selected_Units.empty():
		return false
		
	return true
