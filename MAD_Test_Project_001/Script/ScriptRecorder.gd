extends Node

# https://docs.godotengine.org/en/3.5/classes/class_file.html?highlight=File
# https://docs.godotengine.org/en/3.5/tutorials/scripting/filesystem.html
# https://docs.godotengine.org/en/3.5/tutorials/io/data_paths.html#doc-data-paths

#print(OS.get_data_dir()) # C:\Users\Manix\AppData\Roaming\Godot\app_userdata\MAD

var recording : bool = false
var recordingPath : String = "user://" setget setRecordingPath, getRecordingPath
var recordingFilename : String = "GameRecording_001.tres" setget setRecordingFilename, getRecordingFilename
var gameScript : Resource = null
var dirty : bool = false
var timeOffset : float = 0.0 

func _ready():
	gameScript = GameScript.new()
	
func _process(delta):
	if recording:
		timeOffset = timeOffset + delta
		_writeFile()
			
func _writeFile() -> void:
	if dirty:
		var recordingFilePath = getRecordingFilePath()
		var err = ResourceSaver.save(recordingFilePath, gameScript)
		if err:
			var stringError : String = "Error occured trying to save game script.  Error [" + err + "]"
			push_error(stringError)
		dirty = false

func executeCommand(command) -> void:
	if recording:
		var ret = command.execute()
		if ret:
			recordCommand(command)
	else:
		command.execute()
	
func recordCommand(command) -> void:
	var scriptLine = ScriptLine.new()
	scriptLine.setTimeOffset(timeOffset)
	scriptLine.setCommandName(command.GetName())
	
	var arguments : Dictionary = {}
	var propteryArray = command.get_property_list()
	for property in propteryArray:
		if property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			if property.name != "Command_Name":
				match property.type:
					TYPE_RID: 
						arguments[property.name] = command[property.name].get_id()
					TYPE_OBJECT:
						arguments[property.name] = _processObject(command[property.name])
					TYPE_ARRAY:
						arguments[property.name] = _processArray(command[property.name])
					_: 
						arguments[property.name] = command[property.name]
			
	scriptLine.setCommandArguments(arguments)
	gameScript.GameScript.append(scriptLine)
	
	dirty = true
			
func record():
	recording = true
	_writeFile()
	gameScript.GameScript.clear()
	
func stop():
	recording = false
	_writeFile()
	gameScript.GameScript.clear()
	
func resetTimeOffset() -> void:
	timeOffset = 0.0
"""
	Helper Functions
"""	
func _processArray(array):
	var retArray : Array = []
	
	for i in array:
		match typeof(i):
			TYPE_OBJECT:
				retArray.append(i.get_path ())
			_: 
				retArray.append(i)
	
	return retArray

func _processObject(object):
	var ret : NodePath 
	ret = object.get_path()
	return ret
	
"""
	Accessors
"""
func setRecordingPath(path : String) -> void:
	_writeFile()
	gameScript.GameScript.clear()
	recordingPath = path
	
func getRecordingPath() -> String:
	return recordingPath
	
func setRecordingFilename(filename) -> void:
	_writeFile()
	gameScript.GameScript.clear()
	recordingFilename = filename
	
func getRecordingFilename() -> String:
	return recordingFilename

func getRecordingFilePath() -> String:
	return String(recordingPath + "/" + recordingFilename)
