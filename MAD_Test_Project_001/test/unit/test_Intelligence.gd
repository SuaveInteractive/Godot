extends GutTest

var TestIntelligenceScript = preload("res://GameLogic/Country/Intelligence/Intelligence.gd")
var testIntelligence = null

var TestEntityDetectorScene = preload("res://GameEntities/EntityBehaviours/EntityDetector/EntityDetector.tscn")
var testEntityDetectorObject = null

var IntelInfoRes = load("res://ResourceDefinition/Intelligence/IntelligenceInformation.gd")

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

" Returns and array of [ParentNode, EntityDetectorNode, InformationLevel]"
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
	var intelInfo = IntelInfoRes.new()
	intelInfo.TrackingNodePath = testDectorNodeParent.get_path()
	
	testIntelligence.addIntel(intelInfo, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	assert_eq(testIntelligence.Intel.size(), 1)
	assert_eq(testIntelligence.Intel[intelInfo].detections.size(), 1)

"Same Detector with Multiple detections with the same levels"
func test_addIntelFromDetection_001() -> void:
	var infoLevelArray = []
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.LOW)
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.LOW)
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.LOW)
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.LOW)
	var testData = _createObjectsForDetection(infoLevelArray)

	for k in testData:
		testIntelligence.addIntelFromDetection(testEntityDetectorObject, k[2], k[1])

	assert_eq(testIntelligence.Intel.size(), 4)
	for k in testIntelligence.Intel:
		assert_eq(testIntelligence.Intel[k].detections.size(), 1)

"Same Detector with Multiple detections of differing levels"
func test_addIntelFromDetection_002() -> void:
	var infoLevelArray = []
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.LOW)
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.MEDIUM)
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.HIGH)
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.TOTAL)
	var testData = _createObjectsForDetection(infoLevelArray)

	for k in testData:
		testIntelligence.addIntelFromDetection(testEntityDetectorObject, k[2], k[1])

	assert_eq(testIntelligence.Intel.size(), 4)
	for k in testIntelligence.Intel:
		assert_eq(testIntelligence.Intel[k].detections.size(), 1)
	
"Same Entity with Multiple Detections from different Detectors"
func test_addIntelFromDetection_003() -> void:
	var infoLevelArray = []
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.LOW)
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.MEDIUM)
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.HIGH)
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.TOTAL)
	var testData = _createObjectsForDetection(infoLevelArray)

	for k in testData:
		testIntelligence.addIntelFromDetection(k[1], k[2], testEntityDetectorObject)
		
	var intelInfo = testIntelligence._getIntelInfoForNode(testEntityDetectorObject.get_parent())
	assert_eq(testIntelligence.Intel.size(), 1)
	assert_eq(testIntelligence.Intel[intelInfo].detections.size(), 4)
	
"Duplicate detections don't result in multiple Intel entries"
func test_addIntelFromDetection_004() -> void:
	testDectorNodeParent = add_child_autofree(Node.new())
	testDectorNodeParent.name = "TestDetector_2"

	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.MEDIUM, testEntityDetectorObject)
	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.MEDIUM, testEntityDetectorObject)

	var intelInfo = testIntelligence._getIntelInfoForNode(testEntityDetectorObject.get_parent())
	assert_eq(testIntelligence.Intel.size(), 1)
	assert_eq(testIntelligence.Intel[intelInfo].detections.size(), 1)

"Check to make sure the changed intel is as expected."
func test_changeIntel_001() -> void:
	var intelInfo_01 = IntelInfoRes.new()
	intelInfo_01.TrackingNodePath = testEntityDetectorObject.get_parent().get_path()
	var intelInfo_02 = IntelInfoRes.new()
	intelInfo_02.TrackingNodePath = testEntityDetectorObject.get_parent().get_path()
		
	testIntelligence.addIntel(intelInfo_01, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	testIntelligence.addIntel(intelInfo_02, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	
	simulate(testIntelligence, 5, 0.1)
	
	var intelInfo = testIntelligence._getIntelInfoForNode(testEntityDetectorObject.get_parent())
	testIntelligence.changeIntel(intelInfo, TestIntelligenceScript.InformationLevel.MEDIUM, testEntityDetectorObject)
	
	var EXPECTED_RES  = {intelInfo: TestIntelligenceScript.InformationLevel.MEDIUM}
	assert_eq_deep(EXPECTED_RES, testIntelligence.changedIntel)

"Changing the intel level of an object does not the affect number of entries"
func test_changeIntelFromDetection_001() -> void:
	testDectorNodeParent = add_child_autofree(Node.new())
	testDectorNodeParent.name = "TestDetector_2"

	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.MEDIUM, testEntityDetectorObject)
	testIntelligence.changeIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	
	var intelInfo = testIntelligence._getIntelInfoForNode(testEntityDetectorObject.get_parent())
	assert_eq(testIntelligence.Intel.size(), 1)
	assert_eq(testIntelligence.Intel[intelInfo].detections.size(), 1)
	assert_eq(testIntelligence.Intel[intelInfo].highestIntelLvl, TestIntelligenceScript.InformationLevel.LOW)
	
"Trying to change intel on something that doesn't exist does not change state"
func test_changeIntelFromDetection_002() -> void:
	testDectorNodeParent = add_child_autofree(Node.new())
	testDectorNodeParent.name = "TestDetector_2"

	testIntelligence.changeIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)

	assert_eq(testIntelligence.Intel.size(), 0)
	
"Nothing changes if there is nothing to remove from intelligence"
func test_removeDetection_001() -> void:
	testIntelligence.removeDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)

	assert_eq(testIntelligence.Intel.size(), 0)
	
"There is no intel if previous added detection is removed"
func test_removeDetection_002() -> void:
	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	testIntelligence.removeDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)

	assert_eq(testIntelligence.Intel.size(), 0)

"There is still intel even if one of the information levels is removed"
func test_removeDetection_003() -> void:
	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.MEDIUM, testEntityDetectorObject)

	testIntelligence.removeDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)

	assert_eq(testIntelligence.Intel.size(), 1)
	
"There is still Intel even if one dection is removed"
func test_removeDetection_004() -> void:
	var infoLevelArray = []
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.MEDIUM)
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.HIGH)
	var testData = _createObjectsForDetection(infoLevelArray)

	for k in testData:
		testIntelligence.addIntelFromDetection(testDectorNodeParent, k[2], k[1])

	testIntelligence.removeDetection(testDectorNodeParent, testData[0][2], testData[0][1])

	assert_eq(testIntelligence.Intel.size(), 1)	

"Test an array with a single Information Level"
func test_getHighestIntelligenceForDetection_001() -> void:
	var detectionDic = {}
	detectionDic[1] = TestIntelligenceScript.InformationLevel.LOW

	var res = testIntelligence._getHighestIntelligenceForDetection(detectionDic)

	assert_eq(res, TestIntelligenceScript.InformationLevel.LOW)

"Test an array with a multiple Information Levels"	
func test_getHighestIntelligenceForDetection_002() -> void:
	var detectionDic = {}
	detectionDic[1] = TestIntelligenceScript.InformationLevel.LOW
	detectionDic[2] = TestIntelligenceScript.InformationLevel.MEDIUM
	detectionDic[3] = TestIntelligenceScript.InformationLevel.HIGH
	var res = testIntelligence._getHighestIntelligenceForDetection(detectionDic)

	assert_eq(res, TestIntelligenceScript.InformationLevel.HIGH)

"Get the highest intel for a single Intelligence Dictionary"
func test_getHighestIntelligence_001() -> void:
	var intelDic = {}

	intelDic[testDectorNodeParent] = TestIntelligenceScript.IntelEntry.new()
	intelDic[testDectorNodeParent].highestIntelLvl = TestIntelligenceScript.InformationLevel.LOW	

	var resDic = testIntelligence._getHighestIntelligence(intelDic)

	assert_eq(resDic[testDectorNodeParent], TestIntelligenceScript.InformationLevel.LOW)

"Get the highest intel for a Intelligence Dictionary with multiple entries"
func test_getHighestIntelligence_002() -> void:
	var intelDic = {}
	intelDic[testDectorNodeParent] = TestIntelligenceScript.IntelEntry.new()
	intelDic[testDectorNodeParent].highestIntelLvl = TestIntelligenceScript.InformationLevel.HIGH

	var resDic = testIntelligence._getHighestIntelligence(intelDic)

	assert_eq(resDic[testDectorNodeParent], TestIntelligenceScript.InformationLevel.HIGH)

"Test that there is no known intelligence when nothing has been added"
func test_getKnownIntelligence_001() -> void:
	var res : Dictionary = testIntelligence._getKnownIntelligence()
	assert_eq(res.size(), 0)

"Test that there is intelligence when some has been added"
func test_getKnownIntelligence_002() -> void:
	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)

	var res : Dictionary = testIntelligence._getKnownIntelligence()

	assert_eq(res.size(), 1)	
	
"Test the known trackable intelligence is the same as the entered intelligence"
func test_getKnownTrackableIntelligence_001() -> void:
	var infoLevelArray = []
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.MEDIUM)
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.HIGH)
	var testData = _createObjectsForDetection(infoLevelArray)

	var EXPECTED_RES  = {}
	for k in testData:
		testIntelligence.addIntelFromDetection(testDectorNodeParent, k[2], k[1])
		EXPECTED_RES[k[1].get_parent()] = k[2]
		
	var res : Dictionary = testIntelligence.getKnownTrackableIntelligence()
	assert_eq_deep(EXPECTED_RES, res)	
	
"Test a signal is sent when intel is added"
func test_IntelligenceChanged_Signal_001() -> void:	
	watch_signals(testIntelligence)
	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)

	simulate(testIntelligence, 1, 0.1)

	var intelInfo = testIntelligence._getIntelInfoForNode(testEntityDetectorObject.get_parent())
	var expectedRes = {intelInfo: TestIntelligenceScript.InformationLevel.LOW}
	assert_signal_emitted_with_parameters(testIntelligence, "IntelligenceChanged", [expectedRes])

"Test the correct signal is sent when multiple pieces of intel area added"
func test_IntelligenceChanged_Signal_002() -> void:
	watch_signals(testIntelligence)
	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)

	simulate(testIntelligence, 5, 0.1)

	var intelInfo = testIntelligence._getIntelInfoForNode(testEntityDetectorObject.get_parent())
	var expectedRes = {intelInfo: TestIntelligenceScript.InformationLevel.HIGH}
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
		testIntelligence.addIntelFromDetection(testDectorNodeParent, k[2], k[1])

	simulate(testIntelligence, 5, 0.1)

	var expectedRes = {}
	for k in testData:
		expectedRes[testIntelligence._getIntelInfoForNode(k[0])] = k[2]

	assert_signal_emitted_with_parameters(testIntelligence, "IntelligenceChanged", [expectedRes])

"Test the correct signal is sent when inteligence level changes"
func test_IntelligenceChanged_Signal_004() -> void:
	watch_signals(testIntelligence)

	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)

	simulate(testIntelligence, 5, 0.1)

	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)

	simulate(testIntelligence, 5, 0.1)

	var intelInfo = testIntelligence._getIntelInfoForNode(testEntityDetectorObject.get_parent())
	var expectedRes = {intelInfo: TestIntelligenceScript.InformationLevel.HIGH}
	assert_signal_emitted_with_parameters(testIntelligence, "IntelligenceChanged", [expectedRes])
	
"Test the correct signal is sent when inteligence is removed"
func test_IntelligenceChanged_Signal_005() -> void:
	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)
	simulate(testIntelligence, 5, 0.1)

	watch_signals(testIntelligence)

	# Need to take a copy of the intelInfo before it is removed from the object
	var intelInfo = testIntelligence._getIntelInfoForNode(testEntityDetectorObject.get_parent())
	
	testIntelligence.removeDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)
	simulate(testIntelligence, 5, 0.1)

	var expectedRes = {intelInfo: TestIntelligenceScript.InformationLevel.NONE}
	assert_signal_emitted_with_parameters(testIntelligence, "IntelligenceChanged", [expectedRes])
	
"Test the correct signal is sent when inteligence level is lowered"
func test_IntelligenceChanged_Signal_006() -> void:
	var infoLevelArray = []
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.MEDIUM)
	infoLevelArray.append(TestIntelligenceScript.InformationLevel.HIGH)
	var testData = _createObjectsForDetection(infoLevelArray)

	for k in testData:
		testIntelligence.addIntelFromDetection(k[1], k[2], testEntityDetectorObject)

	simulate(testIntelligence, 5, 0.1)

	watch_signals(testIntelligence)

	var intelInfo = testIntelligence._getIntelInfoForNode(testEntityDetectorObject.get_parent())
	testIntelligence.removeDetection(testData[1][1], TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)
	simulate(testIntelligence, 5, 0.1)

	var expectedRes = {intelInfo: TestIntelligenceScript.InformationLevel.MEDIUM}
	assert_signal_emitted_with_parameters(testIntelligence, "IntelligenceChanged", [expectedRes])

"Test that no additionl signal sent if a lower intelligence level is added after a higher level is added"
func test_IntelligenceChanged_Signal_007() -> void:
	watch_signals(testIntelligence)

	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)

	simulate(testIntelligence, 5, 0.1)

	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)

	simulate(testIntelligence, 5, 0.1)

	assert_signal_emit_count(testIntelligence, "IntelligenceChanged", 1)
	
"No signal is send when nothing is removed"
func test_IntelligenceChanged_Signal_008() -> void:
	# Ignore the first signal sent when the intel is added
	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)
	simulate(testIntelligence, 1, 0.1)

	watch_signals(testIntelligence)
	testIntelligence.removeDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)

	simulate(testIntelligence, 1, 0.1)

	assert_signal_emit_count(testIntelligence, "IntelligenceChanged", 0)
	
"A signal is sent when something is removed"	
func test_IntelligenceChanged_Signal_009() -> void:
	# Ignore the first signal sent when the intel is added
	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)
	simulate(testIntelligence, 1, 0.1)

	watch_signals(testIntelligence)
	testIntelligence.removeDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)

	simulate(testIntelligence, 1, 0.1)

	assert_signal_emit_count(testIntelligence, "IntelligenceChanged", 1)
	
"No signal sent when lower value intelligence is added"	
func test_IntelligenceChanged_Signal_010() -> void:
	# Ignore the first signal sent when the intel is added
	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.HIGH, testEntityDetectorObject)
	simulate(testIntelligence, 1, 0.1)

	watch_signals(testIntelligence)

	testIntelligence.addIntelFromDetection(testDectorNodeParent, TestIntelligenceScript.InformationLevel.LOW, testEntityDetectorObject)
	simulate(testIntelligence, 1, 0.1)

	assert_signal_not_emitted(testIntelligence, "IntelligenceChanged")
