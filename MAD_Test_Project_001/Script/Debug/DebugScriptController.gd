extends Control

signal WindowClosed()

enum STATUS {Idle, Running, Recording}

var Runner = null setget setRunner
var Recorder = null setget setRecorder

onready var currentStatus : Node = $DebugScriptWindow/VBoxContainer/StatusHBoxContainer/CurrentStatus
onready var fileUsed : Node = $DebugScriptWindow/VBoxContainer/FileHBoxContainer/FileUsed

onready var runButton : Node = $DebugScriptWindow/VBoxContainer/RunnerVBoxContainer/RunnerControlHBoxContainer/RunButton
onready var pauseButton : Node = $DebugScriptWindow/VBoxContainer/RunnerVBoxContainer/RunnerControlHBoxContainer/PauseButton
onready var resetButton : Node = $DebugScriptWindow/VBoxContainer/RunnerVBoxContainer/RunnerControlHBoxContainer/ResetButton

onready var startRecordingButton : Node = $DebugScriptWindow/VBoxContainer/RecorderControlHBoxContainer/StartRecordingButton
onready var stopRecordingButton : Node = $DebugScriptWindow/VBoxContainer/RecorderControlHBoxContainer/StopRecordingButton

onready var runOnStartup : Node = $DebugScriptWindow/VBoxContainer/RunnerVBoxContainer/RunScriptOnStartupCheckbox

func _init():
	pass
	
func _ready():
	$DebugScriptWindow.setWindowName("Script Controller")
	
	Runner.connect("ScriptStarted", self, "OnScriptStarted")
	Runner.connect("ScriptFinished", self, "OnScriptFinished")
	
	Recorder.connect("RecordingStarted", self, "OnRecordingStarted")
	Recorder.connect("RecordingFinished", self, "OnRecordingFinished")
	
	var runnerScript = Settings.Get("RunnerScript")
	if runnerScript != null:
		var scriptResource = load(runnerScript)
		_setScriptFilename(scriptResource)
		Runner.setScript(scriptResource)
	
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
	
	runOnStartup.pressed = Settings.Get("RunScriptOnStartup") == true
	
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
	_updateRunnerButtonStates()
	_updateRecorderButtonStates()
	
func _updateRunnerButtonStates() -> void:
	runButton.disabled = true
	pauseButton.disabled = true
	resetButton.disabled = true
	
	if Runner != null && Runner.getScript() != null:
		resetButton.disabled = false
		if Runner.isRunning() == false:
			runButton.disabled = false
		else:
			pauseButton.disabled = false

func _updateRecorderButtonStates() -> void:
	startRecordingButton.disabled = true
	stopRecordingButton.disabled = true
	
	if Recorder != null:
		if Recorder.isRecording():
			stopRecordingButton.disabled = false
		else:
			startRecordingButton.disabled = false
# 
# Callbacks
#
func OnScriptStarted() -> void:
	_update()
	
func OnScriptFinished() -> void:
	_update()
	
func OnRecordingStarted() -> void:
	_update()

func OnRecordingFinished() -> void:
	_update()

func _on_OpenFileDialog_pressed():
	$FileDialog.popup()

func _on_FileDialog_file_selected(path):
	var scriptResource = load(path)
	_setScriptFilename(scriptResource)
	Runner.setScript(scriptResource)
	
	Settings.Set("RunnerScript", path)

func _on_DebugScriptWindow_WindowClosed():
	emit_signal("WindowClosed")

func _on_RunButton_pressed():
	Runner.Run()

func _on_OpenFolderButton_pressed():
	var err = OS.shell_open(ProjectSettings.globalize_path("res://"))
	if err:
		var stringError : String = "[DebugScriptController]: Error occured trying to shell_open res://.  Error [" + err + "]"
		push_error(stringError)
	
func _on_OpenUserFolderButton_pressed():
	var err = OS.shell_open(ProjectSettings.globalize_path("user://"))
	if err:
		var stringError : String = "[DebugScriptController]: Error occured trying to shell_open user://.  Error [" + err + "]"
		push_error(stringError)

func _on_StartRecordingButton_pressed():
	if Recorder != null:
		var dateTimeDic = OS.get_datetime()
		var formatDateTimeString : String  = ""
		formatDateTimeString = formatDateTimeString + str(dateTimeDic["day"])  + "" + str(dateTimeDic["month"])  + "" + str(dateTimeDic["year"]) 
		formatDateTimeString = formatDateTimeString + "_" + str(dateTimeDic["hour"]) + "" + str(dateTimeDic["minute"]) + "" + str(dateTimeDic["second"])
		formatDateTimeString = formatDateTimeString + "_GameRecording.tres"
		Recorder.setRecordingFilename(formatDateTimeString)
		Recorder.record()

func _on_StopRecordingButton_pressed():
	if Recorder != null:
		Recorder.stop()

func _on_RunScriptOnStartupCheckbox_toggled(button_pressed):
	Settings.Set("RunScriptOnStartup", button_pressed)
