extends Node

var ScriptRunnerClass = preload("res://Script/ScriptRunner.gd")
var ScriptRunner = null

var TestCommandScript = preload("res://Script/Debug/TestCommand_001.gd")

var testTimer = 1.0

func _init():
	var testMoveCommand = TestCommandScript.new()
	
	ScriptRunner = ScriptRunnerClass.new()
	ScriptRunner.addCommand(testMoveCommand)
	add_child(ScriptRunner)
	
	
func _ready():
	#recordScript_Test()
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
	
	var testCommand = TestCommandScript.new()
	testCommand.Position_To = Vector2(123, 456)
	testCommand.Selected_Units = [1, "blah"]
	ScriptRecorder.executeCommand(testCommand)
	
	testCommand.Position_To = Vector2(654, 321)
	testCommand.Selected_Units = ["foo", Vector3(1, 2, 3)]
	ScriptRecorder.executeCommand(testCommand)
	
	
	
