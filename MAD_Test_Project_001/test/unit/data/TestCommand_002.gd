extends "res://GameCommand/GameCommand.gd"

var TestObject : Object = null

func _init():
	SetName("Test_Command_002")

func execution() -> bool:
	if TestObject != null:
		return true
	return false
