extends Node

# https://docs.godotengine.org/en/3.5/classes/class_file.html?highlight=File
# https://docs.godotengine.org/en/3.5/tutorials/scripting/filesystem.html
# https://docs.godotengine.org/en/3.5/tutorials/io/data_paths.html#doc-data-paths

#print(OS.get_data_dir()) # C:\Users\Manix\AppData\Roaming\Godot\app_userdata\MAD

var recording : bool = false setget ,isRecording
var recordingPath : String = "user://" setget setRecordingPath, getRecordingPath
var recordingFilename : String = "GameRecording_001.tres" setget setRecordingFilename, getRecordingFilename
var gameScript : Resource = null
var dirty : bool = false
var timeOffset : float = 0.0 

signal RecordingStarted()
signal RecordingFinished()

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
			var stringError : String = "[ScriptRecorder]: Error occured trying to save game script.  Error [" + str(err) + "]"
			push_error(stringError)
		dirty = false

func executeCommand(command) -> bool:
	var ret : bool = false
	if recording:
		ret = command.execution()
		if ret:
			recordCommand(command)
		else:
			var stringError : String = "[ScriptRecorder]: Command failed - not recorded.  Command Name [" + str(command.GetName()) + "]"
			push_error(stringError)
	else:
		ret = command.execution()
	return ret
	
func recordCommand(command) -> void:
	var scriptLine = ScriptLine.new()
	scriptLine.setTimeOffset(timeOffset)
	scriptLine.setCommandName(command.GetName())
	
	var arguments : Dictionary = {}
	var propteryArray = command.get_property_list()
	for property in propteryArray:
		if property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			if property.name != "Command_Name":
				arguments[property.name] = _processArgument(property.type, command[property.name])
			
	scriptLine.setCommandArguments(arguments)
	gameScript.GameScript.append(scriptLine)
	
	dirty = true
	
func isRecording() -> bool:
	return recording
	
func _processArgument(type, variant):
	match type:
		TYPE_RID: 
			var stringError : String = "[ScriptRecorder]: RID Not supported to be serialized.  Look at RIDMapper instead."
			push_error(stringError)
			return null
		TYPE_OBJECT:
			return _processObject(variant)
		TYPE_DICTIONARY :
			return _processDictionary(variant)
		TYPE_ARRAY:
			return _processArray(variant)
		_: 
			return variant
	
func record():
	recording = true
	gameScript.GameScript.clear()
	
	emit_signal("RecordingStarted")
	
func stop():
	recording = false
	_writeFile()
	gameScript.GameScript.clear()
	
	emit_signal("RecordingFinished")
	
func resetTimeOffset() -> void:
	timeOffset = 0.0
"""
	Helper Functions
"""	
func _processRID(var rid : RID):
	RIDMapper.addMapping("processedRID", rid)

func _processObject(object):
	var ret = null 
	if object is Node:
		ret = object.get_path()
	elif object is Resource:
		ret = {}
		var propertyList : Array = object.get_property_list ()
		
		if object is StreamTexture:
			for property in propertyList:
				var propertyValue = object.get(property.name)
				if property.name == "load_path":
					var newArg = _processArgument(property.type, object.get(property.name))
					ret[object] = newArg
		else:	
			for property in propertyList:
				if property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
					var newArg = _processArgument(property.type, object.get(property.name))
					ret[property.name] = newArg
				
		# https://docs.godotengine.org/en/3.5/classes/class_%40globalscope.html#enum-globalscope-propertyusageflags
	else:
		var stringError : String = "[ScriptRecorder]: _processObject not given an Node."
		push_error(stringError)
	return ret

func _processDictionary(dict):
	var ret = {}
	
	for key in dict:
		var val = dict[key]
		var newArg = _processArgument(typeof(val), val)
		ret[key] = newArg
	
	return ret
	

# Need to make sure any entries in the array that cannot be directly serialized are converted into a 
# readable format.
func _processArray(array) -> Array:
	var retArray : Array = []

	for i in array:
		var newArg = _processArgument(typeof(i), i)
		retArray.append(newArg)

	return retArray
	
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
