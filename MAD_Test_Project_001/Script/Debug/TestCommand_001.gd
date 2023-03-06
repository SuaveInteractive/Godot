var Position_To : Vector2
var Selected_Units : Array

var Command_Name : String = "Test_Command_001"

func _init():
	pass
	
func GetName() -> String:
	return Command_Name

func execute() -> bool:
	if Selected_Units.empty():
		return false
		
	return true
