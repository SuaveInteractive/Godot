extends Node

# https://docs.godotengine.org/en/3.5/classes/class_file.html?highlight=File
# https://docs.godotengine.org/en/3.5/tutorials/scripting/filesystem.html
# https://docs.godotengine.org/en/3.5/tutorials/io/data_paths.html#doc-data-paths

var recording : bool = false
var scriptPath : String = "res://Script/Recordings/GameScript001.tres"
var recordingPath : String = "res://Script/Recordings/GameRecording_001.tres"
var gameScript : Resource = null
var dirty : bool = false
var timeOffset : float = 0.0

func _ready():
	gameScript = GameScript.new()
	
func _process(delta):
	if recording:
		timeOffset = timeOffset + delta
		if dirty:
			var err = ResourceSaver.save(recordingPath, gameScript)
			if err:
				print ("Error occured trying to save game script")
			dirty = false

func executeCommand(command) -> void:
	if recording:
		recordCommand(command)
	else:
		command.execute()
	
func recordCommand(command) -> void:
	var ret = command.execute()
	if ret:
		var scriptLine = ScriptLine.new()
		scriptLine.setTimeOffset(timeOffset)
		scriptLine.setCommandName(command.GetName())
		
		var arguments : Dictionary = {}
		var propteryArray = command.get_property_list()
		for property in propteryArray:
			if property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
				if property.name != "Command_Name":
					arguments[property.name] = command[property.name]
				
		scriptLine.setCommandArguments(arguments)
		gameScript.GameScript.append(scriptLine)
		
		dirty = true
	
func record():
	recording = true
	
func stop():
	recording = false
