extends GutTest

var ScriptRunnerClass = preload("res://Script/ScriptRunner.gd")
var ScriptRunner = null

func before_all():		
	ScriptRunner = autofree(ScriptRunnerClass.new())
	
#	var commandScript_001 = autofree(TestCommandScript_001.new())
#	var commandScript_002 = autofree(TestCommandScript_002.new())
#	ScriptRunner.addCommand(commandScript_001)
#	ScriptRunner.addCommand(commandScript_002)

	add_child(ScriptRunner)
	
func after_all():
	assert_no_new_orphans()
	#print_stray_nodes()
	
func test_basic_write_object() -> void:
	pass
