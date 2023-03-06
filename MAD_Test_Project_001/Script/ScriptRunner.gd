extends Node

export(Resource) var CurrentScript = null setget setScript, getScript
export(Dictionary) var CommandMap = {}

func _ready():
	pass
	
func Run():
	if CurrentScript != null:
		for line in CurrentScript.GameScript:
			var commandName = line.getCommandName()
			if CommandMap.has(commandName):
				var command = CommandMap[commandName]
				var commandArgs = line.getCommandArguments()
				
				if commandArgs:
					for arg in commandArgs:
						command[arg] = commandArgs[arg]
				
				var result = command.execute()
				if !result:
					print("Command [", commandName ,"] Did not execute")
			else:
				print("Command [", commandName ,"] Does not exist in Script Mapped Comamnds")
			

func setScript(var script : Resource) -> void:
	CurrentScript = script

func getScript() -> Resource:
	return CurrentScript

func addCommand(var command) -> void:
	var commandName  = command.GetName()
	CommandMap[commandName] = command
