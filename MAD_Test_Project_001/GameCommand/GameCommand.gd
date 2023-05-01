extends Node

# https://en.wikipedia.org/wiki/Command_pattern#:~:text=In%20object%2Doriented%20programming%2C%20the,event%20at%20a%20later%20time.&text=Four%20terms%20always%20associated%20with,%2C%20receiver%2C%20invoker%20and%20client.

var Command_Name : String = "" setget SetName, GetName
	
func execute() -> bool:
	if GetName() == "":
		return false
		
	return ScriptRecorder.executeCommand(self)

func SetName(name) -> void:
	Command_Name = name
	
func GetName() -> String:
	return Command_Name
	
func execution() -> bool:
	return false
