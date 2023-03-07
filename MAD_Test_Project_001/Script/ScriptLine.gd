extends Resource
class_name ScriptLine

export(String) var CommandName = "" setget setCommandName, getCommandName
export(float) var TimeOffset = 0.0 setget setTimeOffset, getTimeOffset
export(Dictionary) var CommandArguments = null setget setCommandArguments, getCommandArguments

func _ready():
	pass
	
func setCommandName(var commandname : String) -> void:
	CommandName = commandname
	
func getCommandName() -> String:
	return CommandName
	
func setCommandArguments(var commandArgs : Dictionary) -> void:
	CommandArguments = commandArgs
	
func getCommandArguments() -> Dictionary:
	return CommandArguments 

func setTimeOffset(timeOffset : float) -> void:
	TimeOffset = timeOffset

func getTimeOffset() -> float:
	return TimeOffset
