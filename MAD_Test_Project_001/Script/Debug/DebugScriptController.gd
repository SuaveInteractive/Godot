extends Control

enum STATUS {Idle, Running, Recording}

var Runner setget setRunner
var Recorder setget setRecorder
	
func _init():
	pass
	
func _ready():
	Runner.connect("ScriptStarted", self, "OnScriptStarted")
	
	_setStatus(STATUS.Idle)
	if Runner.isRunning():
		_setStatus(STATUS.Running)
	
	_setScriptFilename(Runner.getScript())	
		
	
func setRunner(runner):
	Runner = runner

func setRecorder(recorder):
	Recorder = recorder
	
func _setStatus(var status) -> void:
	$DebugScriptWindow/VBoxContainer/StatusHBoxContainer/Status.text = STATUS.keys()[status]
	
func _setScriptFilename(var script : Resource) -> void:
	var filename : String =  "-"
	if script != null:
		filename = script.get_path()
	
	$DebugScriptWindow/VBoxContainer/FileHBoxContainer/FileUsed.text = filename
# 
# Signals
#
func OnScriptStarted():
	pass

# 
# Callbacks
#
func _on_OpenFileDialog_pressed():
	$FileDialog.popup()

func _on_FileDialog_file_selected(path):
	_setScriptFilename(load(path))
