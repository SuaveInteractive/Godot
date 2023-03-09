extends Node

var ScriptRunnerClass = preload("res://Script/ScriptRunner.gd")
var ScriptRunner = null

var TestCommandScript_001 = preload("res://Script/Debug/Commands/TestCommand_001.gd")
var TestCommandScript_002 = preload("res://Script/Debug/Commands/TestCommand_002.gd")

var testTimer = 1.0

func _init():
	ScriptRunner = ScriptRunnerClass.new()
	
	var commandScript_001 = TestCommandScript_001.new()
	var commandScript_002 = TestCommandScript_002.new()
	ScriptRunner.addCommand(commandScript_001)
	ScriptRunner.addCommand(commandScript_002)
	
	add_child(ScriptRunner)
	
	
func _ready():
	recordScript_Test()
	recordScript_Test002()
	runScript_Test()
	
func _process(delta):
	testTimer = testTimer - delta
	if testTimer < 0:
		recordScript_Test()
		testTimer = 600000
	
func runScript_Test() -> void:
	ScriptRunner.setScript(load("res://Script/Debug/Test_GameScript_001.tres"))
	ScriptRunner.Run()
	
func recordScript_Test() -> void:
	ScriptRecorder.record()
	
	var testCommand = TestCommandScript_001.new()
	testCommand.Position_To = Vector2(123, 456)
	testCommand.Selected_Units = [1, "blah"]
	ScriptRecorder.executeCommand(testCommand)
	
	testCommand.Position_To = Vector2(654, 321)
	testCommand.Selected_Units = ["foo", Vector3(1, 2, 3)]
	ScriptRecorder.executeCommand(testCommand)

func recordScript_Test002() -> void:
	ScriptRecorder.setRecordingFilename("Test002.tres")
	ScriptRecorder.record()
	
	var testCommand = TestCommandScript_002.new()
	testCommand.TestSprite = $TestSprite
	ScriptRecorder.executeCommand(testCommand)
	
