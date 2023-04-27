extends Control

signal WindowClosed()

enum STATUS {Idle, Running, Recording}

var Runner = null setget setRunner
var Recorder = null setget setRecorder
	
onready var runButton : Node = $DebugScriptWindow/VBoxContainer/ControlHBoxContainer/RunButton
onready var pauseButton : Node = $DebugScriptWindow/VBoxContainer/ControlHBoxContainer/PauseButton
onready var resetButton : Node = $DebugScriptWindow/VBoxContainer/ControlHBoxContainer/ResetButton
onready var currentStatus : Node = $DebugScriptWindow/VBoxContainer/StatusHBoxContainer/CurrentStatus
onready var fileUsed : Node = $DebugScriptWindow/VBoxContainer/FileHBoxContainer/FileUsed
	
func _init():
	pass
	
func _ready():
	$DebugScriptWindow.setWindowName("Script Controller")
	
	Runner.connect("ScriptStarted", self, "OnScriptStarted")
	Runner.connect("ScriptFinished", self, "OnScriptFinished")
	
	_update()
	
func setRunner(runner):
	Runner = runner

func setRecorder(recorder):
	Recorder = recorder
	
func _update() -> void:
	_setStatus(STATUS.Idle)
	if Runner != null:
		if Runner.isRunning():
			_setStatus(STATUS.Running)
		
		_setScriptFilename(Runner.getScript())	
		
	_updateButtonStates()
	
func _setStatus(var status) -> void:
	currentStatus.text = STATUS.keys()[status]
	
func _setScriptFilename(var script : Resource) -> void:
	var filename : String =  "-"
	runButton.disabled = true
	
	if script != null:
		filename = script.get_path()
		runButton.disabled = false
	
	fileUsed.text = filename

func _updateButtonStates() -> void:
	runButton.disabled = true
	pauseButton.disabled = true
	resetButton.disabled = true
	
	if Runner != null && Runner.getScript() != null:
		resetButton.disabled = false
		if Runner.isRunning() == false:
			runButton.disabled = false
		else:
			pauseButton.disabled = false
# 
# Signals
#
func OnScriptStarted() -> void:
	_update()
	
func OnScriptFinished() -> void:
	_update()

# 
# Callbacks
#
func _on_OpenFileDialog_pressed():
	$FileDialog.popup()

func _on_FileDialog_file_selected(path):
	var scriptResource = load(path)
	_setScriptFilename(scriptResource)
	Runner.setScript(scriptResource)

func _on_DebugScriptWindow_WindowClosed():
	emit_signal("WindowClosed")

func _on_RunButton_pressed():
	Runner.Run()
