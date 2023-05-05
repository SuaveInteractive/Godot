extends GutTest

#	Aiming to test recording and running of Array Argument types

var ScriptRunnerClass = preload("res://Script/ScriptRunner.gd")
var ScriptRunner = null

var newChildContainer : Node = null
var NumberOfChildNodes : int = 3

func _create_script_runner():
	ScriptRunner = add_child_autofree(ScriptRunnerClass.new())
	
func _create_test_objects():
	newChildContainer = Node.new()
	add_child_autofree(newChildContainer)
	
	for i in NumberOfChildNodes:
		var newChildNode = Sprite.new()
		newChildContainer.add_child(newChildNode)

func before_each():
	_create_script_runner()

func test_serialize_numerical_array_object() -> void:
	var testArray : Array = [1, 2, 3, 4, 5, 6]

	var processedArray = ScriptRecorder._processArray(testArray)

	assert_eq(processedArray, testArray)

func test_deserialize_numerical_array_object() -> void:
	var testArray : Array = [1, 2, 3, 4, 5, 6]

	var processedArray = ScriptRunner._processArray(testArray)

	assert_eq(processedArray, testArray)
	
func test_serialize_object_array_object() -> void:
	_create_test_objects()
	
	var testArray : Array = []
	var compareArray : Array = [] # contains the NodePath
	for i in NumberOfChildNodes:
		var childNode = newChildContainer.get_child(i)
		testArray.append(childNode)
		compareArray.append(childNode.get_path())
		
	var processedArray = ScriptRecorder._processArray(testArray)
	
	assert_eq(processedArray, compareArray)

func test_deserialize_object_array_object() -> void:
	_create_test_objects()	
	
	var testArray : Array = []
	var compareArray : Array = [] # contains the Nodes
	for i in NumberOfChildNodes:
		var childNode = newChildContainer.get_child(i)
		testArray.append(childNode.get_path())
		compareArray.append(childNode)
		
	var processedArray = ScriptRunner._processArray(testArray)

	assert_eq(processedArray, compareArray)
