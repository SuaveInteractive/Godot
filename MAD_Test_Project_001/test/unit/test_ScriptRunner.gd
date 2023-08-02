extends GutTest

var ScriptRunnerClass = preload("res://Script/ScriptRunner.gd")
var ScriptRunner = null

var TestCommandScript_001 = preload("res://test/unit/data/TestCommand_001.gd")

func before_all():		
	ScriptRunner = add_child_autofree(ScriptRunnerClass.new())
	
	var commandScript_001 = add_child_autofree(TestCommandScript_001.new())
	ScriptRunner.addCommand(commandScript_001)
	
func after_all():
	assert_no_new_orphans()
	
func test_basic_run_script_01() -> void:
	ScriptRunner.setScript(load("res://test/unit/data/Test_GameScript_001.tres"))
	ScriptRunner.Run()
	ScriptRunner._process(10.0)
	
	assert_eq(ScriptRunner.CommandMap["Test_Command_001"].Position_To, Vector2( 123, 456 ))
	assert_eq(ScriptRunner.CommandMap["Test_Command_001"].Selected_Units, [ 1, "blah" ])

	ScriptRunner._process(10.0)

	assert_eq(ScriptRunner.CommandMap["Test_Command_001"].Position_To, Vector2( 654, 321 ))
	assert_eq(ScriptRunner.CommandMap["Test_Command_001"].Selected_Units, [ "foo", Vector3( 1, 2, 3 ) ])

	ScriptRunner._process(10.0)

	assert_eq(ScriptRunner.CommandMap["Test_Command_001"].Position_To, Vector2( 123, 456 ))
	assert_eq(ScriptRunner.CommandMap["Test_Command_001"].Selected_Units, [ 1, "blah" ])

	ScriptRunner._process(10.0)

	assert_eq(ScriptRunner.CommandMap["Test_Command_001"].Position_To, Vector2( 654, 321 ))
	assert_eq(ScriptRunner.CommandMap["Test_Command_001"].Selected_Units, [ "foo", Vector3( 1, 2, 3 ) ])

	ScriptRunner._process(10.0)
	ScriptRunner._process(10.0)
	ScriptRunner._process(10.0)
