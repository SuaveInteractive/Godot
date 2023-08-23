extends GutTest

var TestIntelligenceScript = preload("res://GameLogic/Country/Intelligence/Intelligence.gd")
var testIntelligence = null

var TestEntityDetectorScene = preload("res://GameEntities/EntityBehaviours/EntityDetector/EntityDetector.tscn")
var testEntityDetectorObject = null

var testDectorNodeParent = null
var testDetectedNodeParent = null

"===== SETUP ====="
func before_each():
	testDectorNodeParent = add_child_autofree(Node.new())
	testDectorNodeParent.name = "TestDetector"
	
	testDetectedNodeParent = add_child_autofree(Node.new())
	
	testEntityDetectorObject = TestEntityDetectorScene.instance()
	testDetectedNodeParent.add_child(testEntityDetectorObject)
	
	testIntelligence = add_child_autofree(TestIntelligenceScript.new())
	
"===== HELPERS ====="
func _createObjectForDetection() -> Array:
	var nodeToDetect = add_child_autofree(Node.new())
	var entityDetectorInstance = TestEntityDetectorScene.instance()
	nodeToDetect.add_child(entityDetectorInstance)
	return [nodeToDetect, entityDetectorInstance]
	
func _createObjectsForDetection(var InformationLevels : Array) -> Array:
	var retArray = []
	
	for i in InformationLevels:
		var detectionObj = _createObjectForDetection()
		detectionObj.append(i)
		retArray.append(detectionObj)
	
	return retArray

"===== TESTS ====="
"Test for Valid and Invalid Entities used by Intelligence"
func test_validEntity_001() -> void:
	assert_true(testIntelligence._validEntity(testEntityDetectorObject))
	assert_false(testIntelligence._validEntity(testDectorNodeParent))

"1 Detector adding 1 detection"
func test_addIntel_001() -> void:
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	assert_eq(testIntelligence.Intel.size(), 1)
	assert_eq(testIntelligence.Intel[testDetectedNodeParent].detections.size(), 1)

"Same Detector adding Multiple Intelligence"
func test_addIntel_002() -> void:
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.MEDIUM, testEntityDetectorObject)
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.TOTAL, testEntityDetectorObject)
	assert_eq(testIntelligence.Intel.size(), 1)
	assert_eq(testIntelligence.Intel[testDetectedNodeParent].detections.size(), 4)

"Seperate Detected"
func test_addIntel_003() -> void:
	var testDectorNodeParent_02 = add_child_autofree(Node.new())
	var testEntityDetectorObject_02 = TestEntityDetectorScene.instance()
	testDectorNodeParent_02.add_child(testEntityDetectorObject_02)

	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject_02)

	assert_eq(testIntelligence.Intel.size(), 2)
	assert_eq(testIntelligence.Intel[testDetectedNodeParent].detections.size(), 1)
	assert_eq(testIntelligence.Intel[testDectorNodeParent_02].detections.size(), 1)
	
"Multiple Detections"
func test_addIntel_004() -> void:
	testDectorNodeParent = add_child_autofree(Node.new())
	testDectorNodeParent.name = "TestDetector_2"

	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.MEDIUM, testEntityDetectorObject)

	assert_eq(testIntelligence.Intel.size(), 1)
	assert_eq(testIntelligence.Intel[testDetectedNodeParent].detections.size(), 2)
	
"Duplicate detections don't result in multiple Intel entries"
func test_addIntel_005() -> void:
	testDectorNodeParent = add_child_autofree(Node.new())
	testDectorNodeParent.name = "TestDetector_2"

	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.MEDIUM, testEntityDetectorObject)
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.MEDIUM, testEntityDetectorObject)

	assert_eq(testIntelligence.Intel.size(), 1)
	assert_eq(testIntelligence.Intel[testDetectedNodeParent].detections.size(), 1)
	
"Nothing changes if there is nothing to remove from intelligence"
func test_removeDetection_001() -> void:
	testIntelligence.removeDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	
	assert_eq(testIntelligence.Intel.size(), 0)
	
"There is no intel if previous added detection is removed"
func test_removeDetection_002() -> void:
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	testIntelligence.removeDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	
	assert_eq(testIntelligence.Intel.size(), 0)

"There is still intel even if one of the information levels is removed"
func test_removeDetection_003() -> void:
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.MEDIUM, testEntityDetectorObject)

	testIntelligence.removeDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)

	assert_eq(testIntelligence.Intel.size(), 1)
	
"There is still Intel even if one dection is removed"
func test_removeDetection_004() -> void:
	var infoLevelArray = []
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.MEDIUM)
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.HIGH)
	var testData = _createObjectsForDetection(infoLevelArray)
	
	for k in testData:
		testIntelligence.addIntel(testDectorNodeParent, k[2], k[1])
		
	testIntelligence.removeDetection(testDectorNodeParent, testData[0][2], testData[0][1])
	
	assert_eq(testIntelligence.Intel.size(), 1)	

"Test an array with a single Information Level"
func test_getHighestIntelligenceForDetection_001() -> void:
	var newDetection_LOW = TestIntelligenceScript.Detection.new()
	newDetection_LOW.detectionLevel = TestIntelligenceScript.InformationLevel.LOW

	var detectionArray = [newDetection_LOW]
	var res = testIntelligence._getHighestIntelligenceForDetection(detectionArray)

	assert_eq(res, TestIntelligenceScript.InformationLevel.LOW)

"Test an array with a multiple Information Levels"	
func test_getHighestIntelligenceForDetection_002() -> void:
	var newDetection_LOW = TestIntelligenceScript.Detection.new()
	newDetection_LOW.detectionLevel = TestIntelligenceScript.InformationLevel.LOW
	var newDetection_MEDIUM = TestIntelligenceScript.Detection.new()
	newDetection_MEDIUM.detectionLevel = TestIntelligenceScript.InformationLevel.MEDIUM
	var newDetection_HIGH = TestIntelligenceScript.Detection.new()
	newDetection_HIGH.detectionLevel = TestIntelligenceScript.InformationLevel.HIGH

	var detectionArray = [newDetection_LOW, newDetection_MEDIUM, newDetection_HIGH]
	var res = testIntelligence._getHighestIntelligenceForDetection(detectionArray)

	assert_eq(res, TestIntelligenceScript.InformationLevel.HIGH)

"Get the highest intel for a single Intelligence Dictionary"
func test_getHighestIntelligence_001() -> void:
	var intelDic = {}

	var newDetection_LOW = TestIntelligenceScript.Detection.new()
	newDetection_LOW.detectionLevel = TestIntelligenceScript.InformationLevel.LOW	

	intelDic[testDectorNodeParent] = []
	intelDic[testDectorNodeParent].append(newDetection_LOW)

	var resDic = testIntelligence._getHighestIntelligence(intelDic)

	assert_eq(resDic[testDectorNodeParent], TestIntelligenceScript.InformationLevel.LOW)

"Get the highest intel for a Intelligence Dictionary with multiple entries"
func test_getHighestIntelligence_002() -> void:
	var intelDic = {}

	var newDetection_LOW = TestIntelligenceScript.Detection.new()
	newDetection_LOW.detectionLevel = TestIntelligenceScript.InformationLevel.LOW	
	var newDetection_HIGH = TestIntelligenceScript.Detection.new()
	newDetection_HIGH.detectionLevel = TestIntelligenceScript.InformationLevel.HIGH

	intelDic[testDectorNodeParent] = []
	intelDic[testDectorNodeParent].append(newDetection_LOW)
	intelDic[testDectorNodeParent].append(newDetection_HIGH)

	var resDic = testIntelligence._getHighestIntelligence(intelDic)

	assert_eq(resDic[testDectorNodeParent], TestIntelligenceScript.InformationLevel.HIGH)

"Test that there is no known intelligence when nothing has been added"
func test_getKnownIntelligence_001() -> void:
	var res : Dictionary = testIntelligence.getKnownIntelligence()
	assert_eq(res.size(), 0)

"Test that there is intelligence when some has been added"
func test_getKnownIntelligence_002() -> void:
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	
	var res : Dictionary = testIntelligence.getKnownIntelligence()
	
	assert_eq(res.size(), 1)	

"Test a signal is sent when intel is added"
func test_IntelligenceChanged_Signal_001() -> void:	
	watch_signals(testIntelligence)
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)

	simulate(testIntelligence, 1, 0.1)

	var expectedRes = {testDetectedNodeParent: TestIntelligenceScript.InformationLevel.LOW}
	assert_signal_emitted_with_parameters(testIntelligence, "IntelligenceChanged", [expectedRes])

"Test the correct signal is sent when multiple pieces of intel area added"
func test_IntelligenceChanged_Signal_002() -> void:
	watch_signals(testIntelligence)
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)

	simulate(testIntelligence, 5, 0.1)

	var expectedRes = {testDetectedNodeParent: TestIntelligenceScript.InformationLevel.HIGH}
	assert_signal_emitted_with_parameters(testIntelligence, "IntelligenceChanged", [expectedRes])

"Test with different detections"
func test_IntelligenceChanged_Signal_003() -> void:
	watch_signals(testIntelligence)

	var infoLevelArray = []
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.MEDIUM)
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.HIGH)
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.HIGH)
	
	var testData = _createObjectsForDetection(infoLevelArray)
	
	for k in testData:
		testIntelligence.addIntel(testDectorNodeParent, k[2], k[1])

	simulate(testIntelligence, 5, 0.1)
	
	var expectedRes = {}
	for k in testData:
		expectedRes[k[0]] = k[2]
		
	assert_signal_emitted_with_parameters(testIntelligence, "IntelligenceChanged", [expectedRes])

"Test the correct signal is sent when inteligence level changes"
func test_IntelligenceChanged_Signal_004() -> void:
	watch_signals(testIntelligence)
	
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	
	simulate(testIntelligence, 5, 0.1)
	
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)
	
	simulate(testIntelligence, 5, 0.1)
	
	var expectedRes = {testDetectedNodeParent: TestIntelligenceScript.InformationLevel.HIGH}
	assert_signal_emitted_with_parameters(testIntelligence, "IntelligenceChanged", [expectedRes])
	
"Test the correct signal is sent when inteligence is removed"
func test_IntelligenceChanged_Signal_005() -> void:
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)
	simulate(testIntelligence, 5, 0.1)
	
	watch_signals(testIntelligence)
	
	testIntelligence.removeDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)
	simulate(testIntelligence, 5, 0.1)
	
	var expectedRes = {testDetectedNodeParent: TestIntelligenceScript.InformationLevel.NONE}
	assert_signal_emitted_with_parameters(testIntelligence, "IntelligenceChanged", [expectedRes])
	
"Test the correct signal is sent when inteligence level is lowered"
func test_IntelligenceChanged_Signal_006() -> void:
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.MEDIUM, testEntityDetectorObject)
	simulate(testIntelligence, 5, 0.1)
	
	watch_signals(testIntelligence)
	
	testIntelligence.removeDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)
	simulate(testIntelligence, 5, 0.1)
	
	var expectedRes = {testDetectedNodeParent: TestIntelligenceScript.InformationLevel.MEDIUM}
	assert_signal_emitted_with_parameters(testIntelligence, "IntelligenceChanged", [expectedRes])

"Test that no additionl signal sent if a lower intelligence level is added after a higher level is added"
func test_IntelligenceChanged_Signal_007() -> void:
	watch_signals(testIntelligence)
	
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)
	
	simulate(testIntelligence, 5, 0.1)
	
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	
	simulate(testIntelligence, 5, 0.1)
	
	assert_signal_emit_count(testIntelligence, "IntelligenceChanged", 1)
	
"No signal is send when nothing is removed"
func test_IntelligenceChanged_Signal_008() -> void:
	# Ignore the first signal sent when the intel is added
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)
	simulate(testIntelligence, 1, 0.1)
	
	watch_signals(testIntelligence)
	testIntelligence.removeDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	
	simulate(testIntelligence, 1, 0.1)
	
	assert_signal_emit_count(testIntelligence, "IntelligenceChanged", 0)
	
"A signal is sent when something is removed"	
func test_IntelligenceChanged_Signal_009() -> void:
	# Ignore the first signal sent when the intel is added
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)
	simulate(testIntelligence, 1, 0.1)
	
	watch_signals(testIntelligence)
	testIntelligence.removeDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)
	
	simulate(testIntelligence, 1, 0.1)
	
	assert_signal_emit_count(testIntelligence, "IntelligenceChanged", 1)
	
"No signal sent when lower value intelligence is added"	
func test_IntelligenceChanged_Signal_010() -> void:
	# Ignore the first signal sent when the intel is added
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)
	simulate(testIntelligence, 1, 0.1)
	
	watch_signals(testIntelligence)
	
	testIntelligence.addIntel(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	simulate(testIntelligence, 1, 0.1)
	
	assert_signal_not_emitted(testIntelligence, "IntelligenceChanged")
