extends "res://GameCommand/GameCommand.gd"

var Position_To : Vector2
var Selected_Units : Array
var Navigation_Mesh : Navigation2D

func _init():
	Command_Name = "Move_Command"

func execute() -> bool:
	if Selected_Units.empty() or Navigation_Mesh == null:
		return false
	
	for unit in Selected_Units:
		if unit.get_node("MoveNode") != null:
			unit.get_node("MoveNode").createPath(Navigation_Mesh, unit.global_position, Position_To)
	
	return true
