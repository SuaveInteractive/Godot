extends Node

export(Resource) var CurrentScript = null setget setScript, getScript
export(Dictionary) var CommandMap = {}

var currentExecutionTime : float = 0.0
var nextTimeOffset : float = 0.0
var currentLineIndex : int = 0
var numberOfScriptLines : int = 0
var runningScript : bool = false setget ,isRunning

signal ScriptStarted()
signal ScriptFinished()

func _init():
	name = "ScriptRunner"
	
func _ready():
	pass
	
func _process(delta):
	if runningScript:
		currentExecutionTime = currentExecutionTime + delta
		if nextTimeOffset < currentExecutionTime:
			var line = _getNextLine()
			if line:
				runningScript = _executeLine(line)
				currentLineIndex = currentLineIndex + 1
				
				_setNextTimeOffset()
			else:
				runningScript = false
				emit_signal("ScriptFinished")
	
func Run():
	if CurrentScript != null:
		currentExecutionTime = 0.0
		nextTimeOffset = 0.0
		currentLineIndex = 0
		numberOfScriptLines = CurrentScript.GameScript.size()
		runningScript = true
		_setNextTimeOffset()
		
		emit_signal("ScriptStarted")
	else:
		print("ScriptRunner: CurrentScript not set")
		
func isRunning() -> bool:
	return runningScript

func _setNextTimeOffset() -> void:
	var line = _getNextLine()
	if line:
		nextTimeOffset = line.getTimeOffset()
	else:
		runningScript = false
		emit_signal("ScriptFinished")

func _getNextLine():
	if currentLineIndex < numberOfScriptLines:
		var line = CurrentScript.GameScript[currentLineIndex]
		return line
	return null

func _executeLine(line) -> bool:
	var result : bool = false
	var commandName = line.getCommandName()
	if CommandMap.has(commandName):
		var command = CommandMap[commandName]
		var commandArgs = line.getCommandArguments()
		
		if commandArgs:
			for arg in commandArgs:
				command[arg] = _processArgument(commandArgs[arg])
		
		result = command.execute()
		if !result:
			print("ScriptRunner: Command [", commandName ,"] did not execute successfully.\n              Arguments [", commandArgs ,"]")

	else:
		print("ScriptRunner: Command [", commandName ,"] Does not exist in Script Mapped Comamnds")
		
	return result
	
func _processArgument(arg):
	match typeof(arg):
		TYPE_NODE_PATH:
			return _processNodePath(arg)
		TYPE_OBJECT:
			return _processObject(arg)
		TYPE_DICTIONARY:
			return _processDictionary(arg)
		TYPE_ARRAY:
			return _processArray(arg)
		_:
			return arg

func setScript(var script : Resource) -> void:
	CurrentScript = script

func getScript() -> Resource:
	return CurrentScript

func addCommand(var command) -> void:
	var commandName  = command.GetName()
	CommandMap[commandName] = command
	
func _processNodePath(nodePath : NodePath) -> Node:
	return get_node(nodePath)
	
func _processObject(nodePathStr : String) -> Node:
	var nodePath = NodePath(nodePathStr)
	return get_node(nodePath)
	
func _processDictionary(dict):
	var ret = {}
	
	for key in dict:
		var val = dict[key]
		var newArg = _processArgument(val)
		ret[key] = newArg
	
	return ret
	
func _processArray(stringArray : Array) -> Array:
	var ret : Array = []
	
	for i in stringArray:
		ret.append(_processArgument(i))
	
	return ret
