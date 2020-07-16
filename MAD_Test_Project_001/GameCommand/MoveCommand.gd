extends "res://GameCommand/GameCommand.gd"

var Position_To : Vector2
var Selected_Units : Array
var Navigation_Mesh : Navigation2D

func _ready():
	Command_Name = "Move_Command"

func execute() -> bool:
	if Selected_Units.empty() or Navigation_Mesh == null:
		return false
	
	for unit in Selected_Units:
		var newPath = Navigation_Mesh.get_simple_path(unit.global_position, Position_To)
		newPath.remove(0);
		unit.path = newPath
	
	return true
