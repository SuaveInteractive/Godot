extends GutTest

#	Aiming to test a Command being able to record and read Objects

var ScriptRunnerClass = preload("res://Script/ScriptRunner.gd")
var ScriptRunner = null

var TestCommandScript_002 = preload("res://test/unit/data//TestCommand_002.gd")
var commandScript_002 = null

func before_all():		
	gut.directory_delete_files(ScriptRecorder.getRecordingPath())
	ScriptRecorder.resetTimeOffset()
	ScriptRecorder.record()
	set_name("Test_Script_Commands_Objects_Node")
	
	ScriptRunner = autofree(ScriptRunnerClass.new())
	
	commandScript_002 = autofree(TestCommandScript_002.new())
	ScriptRunner.addCommand(commandScript_002)
	
	add_child(ScriptRunner)
	
func after_all():
	assert_no_new_orphans()
	
func test_write_object() -> void:
	var newChildNode = Sprite.new()
	newChildNode.name = "TestChildNode"
	add_child_autofree(newChildNode)
	
	commandScript_002.TestObject = newChildNode
	
	ScriptRecorder.executeCommand(commandScript_002)
	simulate(ScriptRecorder, 1, 1.0)
	
	var file1 = autofree(File.new())
	file1.open("res://test/unit/data/test_test_write_object.txt", File.READ)
	var content1 = file1.get_as_text()
	
	var file2 = autofree(File.new())
	file2.open(ScriptRecorder.getRecordingFilePath(), File.READ)
	var content2 = file2.get_as_text()
	
	var temp = get_name()
	
	assert_true(content1 == content2)
	
func test_read_object() -> void:
	pass