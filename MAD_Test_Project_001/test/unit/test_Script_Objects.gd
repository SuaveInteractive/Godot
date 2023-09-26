extends GutTest

#	Aim to test that the Script Runner can write and read Objects

var ScriptRunnerClass = preload("res://Script/ScriptRunner.gd")
var ScriptRunner = null

class NoneGDScriptObject:
	var targetor : Node
	var targets : Array

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

func test_non_gdscript_object() -> void:
	var newChildNode = Sprite.new()
	newChildNode.name = "TestChildNode"
	add_child_autofree(newChildNode)
	
	var newObj = autofree(NoneGDScriptObject.new())
	newObj.targetor = newChildNode
	newObj.targets = [newChildNode]
	
	" Should Error "
	var processedObj = ScriptRecorder._processObject(newObj)
	assert_null(processedObj)

"Test that Resource Types can be written to scripts"
func test_Resource_Object_001() -> void:
	var testString = "WWWWW"
	
	var testResource : Resource = TestResource_001.new()
	testResource.TestData_001 = testString
	
	var processedResource = ScriptRecorder._processObject(testResource)
	
	assert_eq(processedResource["TestData_001"], testString)
	assert_eq(processedResource["TestData_002"], null)
