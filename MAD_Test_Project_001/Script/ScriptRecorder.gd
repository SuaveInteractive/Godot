extends Node

# https://docs.godotengine.org/en/3.5/classes/class_file.html?highlight=File
# https://docs.godotengine.org/en/3.5/tutorials/scripting/filesystem.html
# https://docs.godotengine.org/en/3.5/tutorials/io/data_paths.html#doc-data-paths

var recording : bool = false
var scriptPath : String = "res://Script/Recordings/GameScript001.tres"
var recordingPath : String = "res://Script/Recordings/GameRecording_001.tres"
var gameScript : Resource = null

func _ready():
	gameScript = GameScript.new()
	
func _process(delta):
	if recording:
		var err = ResourceSaver.save(recordingPath, gameScript)
		if err:
			print ("Error occured trying to save game script")

func executeCommand(command) -> bool:
	if recording:
		return recordCommand(command)
	else:
		return command.execute()
	
func recordCommand(command) -> bool:
	var ret = command.execute()
	if ret:
		var scriptLine = ScriptLine.new()
		scriptLine.setCommandName(command.GetName())
		
		var arguments : Dictionary = {}
		var propteryArray = command.get_property_list()
		for property in propteryArray:
			if property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
				arguments[property.name] = command[property.name]
				
		scriptLine.setCommandArguments(arguments)
		gameScript.GameScript.append(scriptLine)
		
	return ret
	
func record():
	recording = true
	
func stop():
	recording = false
