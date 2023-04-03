extends GutTest

#	Aim to test that the Script Runner can write and read Objects

var ScriptRunnerClass = preload("res://Script/ScriptRunner.gd")
var ScriptRunner = null

func before_all():		
	pass
	
func after_all():
	assert_no_new_orphans()
	
func test_basic_serialize_object() -> void:
	var newChildNode = Sprite.new()
	newChildNode.name = "TestChildNode"
	add_child_autofree(newChildNode)
	
	var processedObj = ScriptRecorder._processObject(newChildNode)
	var stringNodePath = String(processedObj)
	
	var currentPath = get_path()
	var currentPathString = String(currentPath)
	currentPathString = currentPathString + "/" + "TestChildNode"
	
	assert_eq(currentPathString, stringNodePath)

func test_basic_parse_object() -> void:
	var newChildNode = Sprite.new()
	newChildNode.name = "TestChildNode"
	add_child_autofree(newChildNode)
	
	ScriptRunner = autofree(ScriptRunnerClass.new())
	add_child_autofree(ScriptRunner)
	var spritePath = newChildNode.get_path()
	
	var node = ScriptRunner._processObject(String(spritePath))
	assert_not_null(node)