extends GutTest

var TestCommandScript_001 = preload("res://test/unit/data//TestCommand_001.gd")
	
func before_each():
	gut.directory_delete_files(ScriptRecorder.getRecordingPath())
	
func after_each():
	assert_no_new_orphans()
	
func test_file_does_not_exists():
	ScriptRecorder.record()
	assert_file_does_not_exist(ScriptRecorder.getRecordingFilePath())
	
func test_file_exists():
	ScriptRecorder.record()
	var testCommand = TestCommandScript_001.new()
	testCommand.Position_To = Vector2(123, 456)
	testCommand.Selected_Units = [1, "blah"]
	ScriptRecorder.executeCommand(testCommand)
	
	ScriptRecorder._process(0.0)
	
	assert_file_exists(ScriptRecorder.getRecordingFilePath())

func test_basic_recording_01():
	ScriptRecorder.resetTimeOffset()
	ScriptRecorder.record()
	
	var testCommand = TestCommandScript_001.new()
	testCommand.Position_To = Vector2(123, 456)
	testCommand.Selected_Units = [1, "blah"]
	ScriptRecorder.executeCommand(testCommand)
	
	testCommand.Position_To = Vector2(654, 321)
	testCommand.Selected_Units = ["foo", Vector3(1, 2, 3)]
	ScriptRecorder.executeCommand(testCommand)
	
	ScriptRecorder._process(0.0)
	
	var file1 = autofree(File.new())
	file1.open("res://test/unit/data/test_basic_recording_01.tres", File.READ)
	var referenceContent = file1.get_as_text()
	
	var file2 = autofree(File.new())
	file2.open(ScriptRecorder.getRecordingFilePath(), File.READ)
	var content2 = file2.get_as_text()
	
	assert_file_exists(ScriptRecorder.getRecordingFilePath())
	assert_true(referenceContent == content2)
