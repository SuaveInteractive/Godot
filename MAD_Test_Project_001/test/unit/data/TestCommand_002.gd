var TestObject : Object = null

var Command_Name : String = "Test_Command_002"

func _init():
	pass
	
func GetName() -> String:
	return Command_Name

func execute() -> bool:
	return true
