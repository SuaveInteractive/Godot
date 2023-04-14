extends "res://GameCommand/GameCommand.gd"

var Position_To : Vector2
var Selected_Units : Array
var MapName : String

func _init():
	Command_Name = "Move_Command"

func execute() -> bool:
	if Selected_Units.empty():
		return false
		
	if MapName.empty():
		return false
		
	var MapID = RIDMapper.getMapping(MapName)
	if MapID.get_id () == 0:
		return false
	
	for unit in Selected_Units:
		if unit.get_node("MoveNode") != null:
			unit.get_node("MoveNode").createPath(MapID, unit.global_position, Position_To)
	
	return true
	
