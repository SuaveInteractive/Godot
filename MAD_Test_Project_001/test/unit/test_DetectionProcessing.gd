extends GutTest

var TestDetectionProcessingScript = preload("res://GameLogic/Country/DetectionProcessing.gd")
var testDetectionProcessing = null

var testNode_01 : Node = null

"===== SETUP ====="
func before_each():
	testDetectionProcessing = add_child_autofree(TestDetectionProcessingScript.new())
	
	testNode_01 = add_child_autofree(Node.new())
	
"===== HELPERS ====="
class FixedNumberRandomizer:
	extends RandomNumberGenerator
	
	var fixedValue : float = 0.1
	
	func randf():
		return fixedValue

class FixedSequenceRandomizer:
	extends RandomNumberGenerator
	
	var retValues : Array = []
	var count : int = 0
	
	func randf():
		var val = retValues[count]
		count = count + 1
		return val
		
func createTestNodes(var numberOfNodes : int) -> Array:
	var retArray : Array = []
	
	for i in numberOfNodes:
		retArray.append(add_child_autofree(Node.new()))
	
	return retArray

"===== TESTS ====="
"Extreme boundaries of the detection levels 0.0-1.0"
func test_testDetectionLevel_001() -> void:
	var fixedVal : float = 0.1
	
	assert_true(testDetectionProcessing._testDetectionLevel(TestDetectionProcessingScript.DetectionLevels.LOW, fixedVal))
	assert_true(testDetectionProcessing._testDetectionLevel(TestDetectionProcessingScript.DetectionLevels.MEDIUM, fixedVal))
	assert_true(testDetectionProcessing._testDetectionLevel(TestDetectionProcessingScript.DetectionLevels.HIGH, fixedVal))
	assert_true(testDetectionProcessing._testDetectionLevel(TestDetectionProcessingScript.DetectionLevels.TOTAL, fixedVal))
	
	fixedVal = 1.1

	assert_false(testDetectionProcessing._testDetectionLevel(TestDetectionProcessingScript.DetectionLevels.LOW, fixedVal))
	assert_false(testDetectionProcessing._testDetectionLevel(TestDetectionProcessingScript.DetectionLevels.MEDIUM, fixedVal))
	assert_false(testDetectionProcessing._testDetectionLevel(TestDetectionProcessingScript.DetectionLevels.HIGH, fixedVal))
	assert_false(testDetectionProcessing._testDetectionLevel(TestDetectionProcessingScript.DetectionLevels.TOTAL, fixedVal))

"The sequence of values from 0.1 to 1.0 test correctly"
func test_testDetectionLevel_002() -> void:
	assert_true(testDetectionProcessing._testDetectionLevel(TestDetectionProcessingScript.DetectionLevels.MEDIUM, 0.1))
	assert_true(testDetectionProcessing._testDetectionLevel(TestDetectionProcessingScript.DetectionLevels.MEDIUM, 0.2))
	assert_true(testDetectionProcessing._testDetectionLevel(TestDetectionProcessingScript.DetectionLevels.MEDIUM, 0.3))
	assert_true(testDetectionProcessing._testDetectionLevel(TestDetectionProcessingScript.DetectionLevels.MEDIUM, 0.4))
	assert_true(testDetectionProcessing._testDetectionLevel(TestDetectionProcessingScript.DetectionLevels.MEDIUM, 0.5))
	assert_false(testDetectionProcessing._testDetectionLevel(TestDetectionProcessingScript.DetectionLevels.MEDIUM, 0.6))
	assert_false(testDetectionProcessing._testDetectionLevel(TestDetectionProcessingScript.DetectionLevels.MEDIUM, 0.7))
	assert_false(testDetectionProcessing._testDetectionLevel(TestDetectionProcessingScript.DetectionLevels.MEDIUM, 0.8))
	assert_false(testDetectionProcessing._testDetectionLevel(TestDetectionProcessingScript.DetectionLevels.MEDIUM, 0.9))
	assert_false(testDetectionProcessing._testDetectionLevel(TestDetectionProcessingScript.DetectionLevels.MEDIUM, 1.0))

"NONE is returned if no levels passed to _testDectectionLevels"
func test_testDectectionLevels_001() -> void:
	assert_eq(testDetectionProcessing._testDectectionLevels([]), TestDetectionProcessingScript.DetectionLevels.NONE)

"NONE is returned if the level passed into _testDectectionLevels fails"	
func test_testDectectionLevels_002() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = 1.0
	
	var levels = [TestDetectionProcessingScript.DetectionLevels.MEDIUM]
	
	assert_eq(testDetectionProcessing._testDectectionLevels(levels), TestDetectionProcessingScript.DetectionLevels.NONE)
	
"NONE is not returned if the level passed into _testDectectionLevels succeeds"	
func test_testDectectionLevels_003() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = 0.0
	
	var levels = [TestDetectionProcessingScript.DetectionLevels.MEDIUM]
	
	assert_eq(testDetectionProcessing._testDectectionLevels(levels), TestDetectionProcessingScript.DetectionLevels.MEDIUM)
	
"NONE is returned if all levels passed into _testDectectionLevels fail"	
func test_testDectectionLevels_004() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = 1.0
	
	var levels = []
	levels.append(TestDetectionProcessingScript.DetectionLevels.LOW)
	levels.append(TestDetectionProcessingScript.DetectionLevels.MEDIUM)
	levels.append(TestDetectionProcessingScript.DetectionLevels.HIGH)
	
	assert_eq(testDetectionProcessing._testDectectionLevels(levels), TestDetectionProcessingScript.DetectionLevels.NONE)
	
"HIGH is returned if both LOW and HIGH have been detected"	
func test_testDectectionLevels_005() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW
	
	var levels = []
	levels.append(TestDetectionProcessingScript.DetectionLevels.LOW)
	levels.append(TestDetectionProcessingScript.DetectionLevels.HIGH)
	
	assert_eq(testDetectionProcessing._testDectectionLevels(levels), TestDetectionProcessingScript.DetectionLevels.HIGH)
	
"HIGH is returned if only HIGH have been detected"
func test_testDectectionLevels_006() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_MEDIUM

	var levels = []
	levels.append(TestDetectionProcessingScript.DetectionLevels.LOW)
	levels.append(TestDetectionProcessingScript.DetectionLevels.HIGH)

	assert_eq(testDetectionProcessing._testDectectionLevels(levels), TestDetectionProcessingScript.DetectionLevels.HIGH)

"No signal sent when not detecting with a single entry"
func test_testDetection_001() -> void:
	watch_signals(testDetectionProcessing)

	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = 1.0

	var detectionStatus = TestDetectionProcessingScript.DetectionStatus.new()
	var detectorStatus = TestDetectionProcessingScript.DetectorStatus.new()
	detectorStatus.detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.MEDIUM)

	detectionStatus.detectors[testNode_01] = detectorStatus

	testDetectionProcessing._testDetection(detectionStatus, testNode_01)

	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "ChangedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")

"A 'GainedDetection' signal sent when detecting with a single entry"
func test_testDetection_002() -> void:	
	watch_signals(testDetectionProcessing)

	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = 0.0

	var detectionStatus = TestDetectionProcessingScript.DetectionStatus.new()
	var detectorStatus = TestDetectionProcessingScript.DetectorStatus.new()
	detectorStatus.detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.MEDIUM)

	detectionStatus.detectors[testNode_01] = detectorStatus

	testDetectionProcessing._testDetection(detectionStatus, testNode_01)

	var expectedRes = [testNode_01, TestDetectionProcessingScript.DetectionLevels.MEDIUM, testNode_01]
	assert_signal_emitted_with_parameters(testDetectionProcessing, "GainedDetection", expectedRes)

	assert_signal_not_emitted(testDetectionProcessing, "ChangedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")

"No signal is sent when not detecting an entry which has mutliple detectors"
func test_testDetection_003() -> void:	
	watch_signals(testDetectionProcessing)

	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = 1.0

	var detectionStatus = TestDetectionProcessingScript.DetectionStatus.new()
	var detectorStatus = TestDetectionProcessingScript.DetectorStatus.new()
	detectorStatus.detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.LOW)
	detectorStatus.detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.MEDIUM)
	detectorStatus.detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.HIGH)

	detectionStatus.detectors[testNode_01] = detectorStatus

	testDetectionProcessing._testDetection(detectionStatus, testNode_01)
	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "ChangedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")
	
"A 'GainedDetection' signal sent when detecting with a multiple detection levels"
func test_testDetection_004() -> void:	
	watch_signals(testDetectionProcessing)

	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_MEDIUM

	var detectionStatus = TestDetectionProcessingScript.DetectionStatus.new()
	var detectorStatus = TestDetectionProcessingScript.DetectorStatus.new()
	detectorStatus.detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.LOW)
	detectorStatus.detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.MEDIUM)
	detectorStatus.detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.HIGH)

	detectionStatus.detectors[testNode_01] = detectorStatus

	testDetectionProcessing._testDetection(detectionStatus, testNode_01)
	
	var expectedRes = [testNode_01, TestDetectionProcessingScript.DetectionLevels.HIGH, testNode_01]
	assert_signal_emitted_with_parameters(testDetectionProcessing, "GainedDetection", expectedRes)
	
	assert_signal_not_emitted(testDetectionProcessing, "ChangedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")
	
"A 'ChangedDetection' signal is sent when the detection level of an object has changed"
func test_testDetection_005() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW

	var detectionStatus = TestDetectionProcessingScript.DetectionStatus.new()
	var detectorStatus = TestDetectionProcessingScript.DetectorStatus.new()
	detectorStatus.detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.LOW)

	detectionStatus.detectors[testNode_01] = detectorStatus

	testDetectionProcessing._testDetection(detectionStatus, testNode_01)

	watch_signals(testDetectionProcessing)

	detectorStatus.detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.MEDIUM)
	testDetectionProcessing._testDetection(detectionStatus, testNode_01)

	var expectedRes = [testNode_01, TestDetectionProcessingScript.DetectionLevels.MEDIUM, testNode_01]
	assert_signal_emitted_with_parameters(testDetectionProcessing, "ChangedDetection", expectedRes)

	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")
	
"A 'ChangedDetection' signal is sent when the detection level of an object is reduced"
func test_testDetection_006() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW

	var detectionStatus = TestDetectionProcessingScript.DetectionStatus.new()
	var detectorStatus = TestDetectionProcessingScript.DetectorStatus.new()
	detectorStatus.detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.LOW)
	detectorStatus.detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.MEDIUM)

	detectionStatus.detectors[testNode_01] = detectorStatus

	testDetectionProcessing._testDetection(detectionStatus, testNode_01)

	watch_signals(testDetectionProcessing)

	detectorStatus.detectionLevels.erase(TestDetectionProcessingScript.DetectionLevels.MEDIUM)
	testDetectionProcessing._testDetection(detectionStatus, testNode_01)

	var expectedRes = [testNode_01, TestDetectionProcessingScript.DetectionLevels.LOW, testNode_01]
	assert_signal_emitted_with_parameters(testDetectionProcessing, "ChangedDetection", expectedRes)

	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")

"A signal is not sent if the same detection level is added."
func test_testDetection_007() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW

	var detectionStatus = TestDetectionProcessingScript.DetectionStatus.new()
	var detectorStatus = TestDetectionProcessingScript.DetectorStatus.new()
	detectorStatus.detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.MEDIUM)

	detectionStatus.detectors[testNode_01] = detectorStatus

	testDetectionProcessing._testDetection(detectionStatus, testNode_01)

	watch_signals(testDetectionProcessing)

	detectorStatus.detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.MEDIUM)
	testDetectionProcessing._testDetection(detectionStatus, testNode_01)

	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "ChangedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")

"A 'LostDetection' signal is sent once an entity loses detection."
func test_testDetection_008() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW

	var detectionStatus = TestDetectionProcessingScript.DetectionStatus.new()
	var detectorStatus = TestDetectionProcessingScript.DetectorStatus.new()
	detectorStatus.detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.MEDIUM)

	detectionStatus.detectors[testNode_01] = detectorStatus

	testDetectionProcessing._testDetection(detectionStatus, testNode_01)

	watch_signals(testDetectionProcessing)

	detectorStatus.detectionLevels.erase(TestDetectionProcessingScript.DetectionLevels.MEDIUM)
	testDetectionProcessing._testDetection(detectionStatus, testNode_01)
	
	var expectedRes = [testNode_01, TestDetectionProcessingScript.DetectionLevels.MEDIUM]
	assert_signal_emitted_with_parameters(testDetectionProcessing, "LostDetection", expectedRes)

	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "ChangedDetection")
	
"A 'GainedDetection' signal is sent when there are multiple detectors and one detects the entity."
func test_testDetection_009() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW

	var detectionStatus = TestDetectionProcessingScript.DetectionStatus.new()

	detectionStatus.detectors[testNode_01] = TestDetectionProcessingScript.DetectorStatus.new()
	detectionStatus.detectors[testNode_01].detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.LOW)
	
	var testNodes = createTestNodes(2)
	detectionStatus.detectors[testNodes[0]] = TestDetectionProcessingScript.DetectorStatus.new()
	detectionStatus.detectors[testNodes[0]].detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.LOW)
	
	detectionStatus.detectors[testNodes[1]] = TestDetectionProcessingScript.DetectorStatus.new()
	detectionStatus.detectors[testNodes[1]].detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.MEDIUM)
	
	watch_signals(testDetectionProcessing)

	testDetectionProcessing._testDetection(detectionStatus, testNode_01)
	
	var expectedRes = [testNode_01, TestDetectionProcessingScript.DetectionLevels.MEDIUM, testNodes[1]]
	assert_signal_emitted_with_parameters(testDetectionProcessing, "GainedDetection", expectedRes)
	
	assert_signal_not_emitted(testDetectionProcessing, "ChangedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")
	
"A 'ChangedDetection' signal is sent when there are multiple detectors and detection changes from one to another."
func test_testDetection_010() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW

	var detectionStatus = TestDetectionProcessingScript.DetectionStatus.new()

	detectionStatus.detectors[testNode_01] = TestDetectionProcessingScript.DetectorStatus.new()
	detectionStatus.detectors[testNode_01].detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.LOW)
	
	testDetectionProcessing._testDetection(detectionStatus, testNode_01)
	
	var testNodes = createTestNodes(2)
	detectionStatus.detectors[testNodes[0]] = TestDetectionProcessingScript.DetectorStatus.new()
	detectionStatus.detectors[testNodes[0]].detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.LOW)
	
	detectionStatus.detectors[testNodes[1]] = TestDetectionProcessingScript.DetectorStatus.new()
	detectionStatus.detectors[testNodes[1]].detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.MEDIUM)
	
	watch_signals(testDetectionProcessing)

	testDetectionProcessing._testDetection(detectionStatus, testNode_01)
	
	var expectedRes = [testNode_01, TestDetectionProcessingScript.DetectionLevels.MEDIUM, testNodes[1]]
	assert_signal_emitted_with_parameters(testDetectionProcessing, "ChangedDetection", expectedRes)
	
	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")
	
"A 'ChangedDetection' signal is sent when there are multiple detectors and detection changes from one to another."
func test_testDetection_011() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW

	var detectionStatus = TestDetectionProcessingScript.DetectionStatus.new()

	detectionStatus.detectors[testNode_01] = TestDetectionProcessingScript.DetectorStatus.new()
	detectionStatus.detectors[testNode_01].detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.LOW)
	
	var testNodes = createTestNodes(2)
	detectionStatus.detectors[testNodes[0]] = TestDetectionProcessingScript.DetectorStatus.new()
	detectionStatus.detectors[testNodes[0]].detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.LOW)
	
	detectionStatus.detectors[testNodes[1]] = TestDetectionProcessingScript.DetectorStatus.new()
	detectionStatus.detectors[testNodes[1]].detectionLevels.append(TestDetectionProcessingScript.DetectionLevels.MEDIUM)

	testDetectionProcessing._testDetection(detectionStatus, testNode_01)
	
	watch_signals(testDetectionProcessing)
	
	detectionStatus.detectors.erase(testNodes[1])
	testDetectionProcessing._testDetection(detectionStatus, testNode_01)
	
	var expectedRes = [testNode_01, TestDetectionProcessingScript.DetectionLevels.LOW, testNode_01]
	assert_signal_emitted_with_parameters(testDetectionProcessing, "ChangedDetection", expectedRes)
	
	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")

"Nothing happens if nothing is passed into 'addDetection'"
func test_addDetection_001() -> void:
	watch_signals(testDetectionProcessing)

	testDetectionProcessing.addDetection(null, null, null)

	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "ChangedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")

"A 'GainedDetection' Signal is send when an object is detected for the first time via 'addDetection'"
func test_addDetection_002() -> void:
	watch_signals(testDetectionProcessing)

	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW

	var testNodes = createTestNodes(2)
	testDetectionProcessing.addDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.HIGH, testNodes[1])

	var expectedRes = [testNodes[1], TestDetectionProcessingScript.DetectionLevels.HIGH, testNodes[0]]
	assert_signal_emitted_with_parameters(testDetectionProcessing, "GainedDetection", expectedRes)

	assert_signal_not_emitted(testDetectionProcessing, "ChangedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")

"A 'ChangedDetection' Signal is send when a previous detected is lower than a new detection added via 'addDetection'"
func test_addDetection_003() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW

	var testNodes = createTestNodes(2)
	testDetectionProcessing.addDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.LOW, testNode_01)

	watch_signals(testDetectionProcessing)
	testDetectionProcessing.addDetection(testNodes[1], TestDetectionProcessingScript.DetectionLevels.HIGH, testNode_01)

	var expectedRes = [testNode_01, TestDetectionProcessingScript.DetectionLevels.HIGH, testNodes[1]]
	assert_signal_emitted_with_parameters(testDetectionProcessing, "ChangedDetection", expectedRes)

	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")
	
"No Signal is send when a previous detected is higher than a new detection added via 'addDetection'"
func test_addDetection_004() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW

	var testNodes = createTestNodes(2)
	testDetectionProcessing.addDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.HIGH, testNode_01)

	watch_signals(testDetectionProcessing)

	testDetectionProcessing.addDetection(testNodes[1], TestDetectionProcessingScript.DetectionLevels.LOW, testNode_01)

	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "ChangedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")

"No Signal is send when a previous detected is the same level as a new detection added via 'addDetection'"
func test_addDetection_005() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW

	var testNodes = createTestNodes(2)
	testDetectionProcessing.addDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.HIGH, testNode_01)

	watch_signals(testDetectionProcessing)

	testDetectionProcessing.addDetection(testNodes[1], TestDetectionProcessingScript.DetectionLevels.HIGH, testNode_01)

	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "ChangedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")

"Nothing happens if nothing is passed into 'removeDetection'"
func test_removeDetection_001() -> void:
	watch_signals(testDetectionProcessing)

	testDetectionProcessing.removeDetection(null, null, null)

	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "ChangedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")

"No signal is sent if any of the parameters passed to 'removeDetection' are invalid"
func test_removeDetection_002() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW

	var testNodes = createTestNodes(2)
	testDetectionProcessing.addDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.HIGH, testNodes[1])

	watch_signals(testDetectionProcessing)

	testDetectionProcessing.removeDetection(testNodes[1], TestDetectionProcessingScript.DetectionLevels.HIGH, testNodes[1])
	testDetectionProcessing.removeDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.LOW, testNodes[1])
	testDetectionProcessing.removeDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.HIGH, testNodes[0])

	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "ChangedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")

"'LostDetection' Signal is sent when the last detection level is removed"
func test_removeDetection_003() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW

	var testNodes = createTestNodes(2)
	testDetectionProcessing.addDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.HIGH, testNodes[1])

	watch_signals(testDetectionProcessing)

	testDetectionProcessing.removeDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.HIGH, testNodes[1])

	var expectedRes = [testNodes[1], TestDetectionProcessingScript.DetectionLevels.HIGH]
	assert_signal_emitted_with_parameters(testDetectionProcessing, "LostDetection", expectedRes)

	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "ChangedDetection")

"'ChangedDetection' Signal is sent when a current higher detection is removed"
func test_removeDetection_004() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW

	var testNodes = createTestNodes(2)
	testDetectionProcessing.addDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.MEDIUM, testNodes[1])
	testDetectionProcessing.addDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.HIGH, testNodes[1])

	watch_signals(testDetectionProcessing)

	testDetectionProcessing.removeDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.HIGH, testNodes[1])

	var expectedRes = [testNodes[1], TestDetectionProcessingScript.DetectionLevels.MEDIUM, testNodes[0]]
	assert_signal_emitted_with_parameters(testDetectionProcessing, "ChangedDetection", expectedRes)

	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")
	
"No signal is sent if the detection of an Entity changes from one detector to another"
func test_removeDetection_005() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW
	
	var testNodes = createTestNodes(2)
	testDetectionProcessing.addDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.MEDIUM, testNode_01)
	testDetectionProcessing.addDetection(testNodes[1], TestDetectionProcessingScript.DetectionLevels.MEDIUM, testNode_01)
	
	watch_signals(testDetectionProcessing)
	
	testDetectionProcessing.removeDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.MEDIUM, testNode_01)
	
	var expectedRes = [testNode_01, TestDetectionProcessingScript.DetectionLevels.MEDIUM, testNodes[1]]
	assert_signal_emitted_with_parameters(testDetectionProcessing, "ChangedDetection", expectedRes)
	
	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")
	
"'ChangedDetection' Signal is sent if the highest detector is removed "
func test_removeDetection_006() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW
	
	var testNodes = createTestNodes(2)
	testDetectionProcessing.addDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.MEDIUM, testNode_01)
	testDetectionProcessing.addDetection(testNodes[1], TestDetectionProcessingScript.DetectionLevels.LOW, testNode_01)
	
	watch_signals(testDetectionProcessing)
	
	testDetectionProcessing.removeDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.MEDIUM, testNode_01)
	
	var expectedRes = [testNode_01, TestDetectionProcessingScript.DetectionLevels.LOW, testNodes[1]]
	assert_signal_emitted_with_parameters(testDetectionProcessing, "ChangedDetection", expectedRes)
	
	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")

"No Signal is sent if there is no data"
func test_process_001() -> void:
	watch_signals(testDetectionProcessing)
	
	simulate(testDetectionProcessing, 3.0*5, 0.5)
	
	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "ChangedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")
	
"No Signal is sent if there is no change to detection"
func test_process_002() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW
	
	var testNodes = createTestNodes(2)
	testDetectionProcessing.addDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.LOW, testNode_01)
	
	watch_signals(testDetectionProcessing)
	
	simulate(testDetectionProcessing, 3.0*5, 0.5)
	
	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "ChangedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")

"'GainedDetection' Signal is sent if a previous detected entity is updated and gains detection"
func test_process_003() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_TOTAL
	
	var testNodes = createTestNodes(2)
	testDetectionProcessing.addDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.LOW, testNodes[1])
	
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW
	
	watch_signals(testDetectionProcessing)
	
	simulate(testDetectionProcessing, 3.0*5, 0.5)
	
	var expectedRes = [testNodes[1], TestDetectionProcessingScript.DetectionLevels.LOW, testNodes[0]]
	assert_signal_emitted_with_parameters(testDetectionProcessing, "GainedDetection", expectedRes)
	
	assert_signal_not_emitted(testDetectionProcessing, "LostDetection")
	assert_signal_not_emitted(testDetectionProcessing, "ChangedDetection")	

"'LostDetection' Signal is sent if a previous detected entity is updated and loses detection"
func test_process_004() -> void:
	testDetectionProcessing.Randomizer = FixedNumberRandomizer.new()
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_LOW
	
	var testNodes = createTestNodes(2)
	testDetectionProcessing.addDetection(testNodes[0], TestDetectionProcessingScript.DetectionLevels.LOW, testNodes[1])
	
	testDetectionProcessing.Randomizer.fixedValue = testDetectionProcessing.detectionChance_TOTAL
	
	watch_signals(testDetectionProcessing)
	
	simulate(testDetectionProcessing, 3.0*5, 0.5)
	
	var expectedRes = [testNodes[1], TestDetectionProcessingScript.DetectionLevels.LOW]
	assert_signal_emitted_with_parameters(testDetectionProcessing, "LostDetection", expectedRes)
	
	assert_signal_not_emitted(testDetectionProcessing, "GainedDetection")
	assert_signal_not_emitted(testDetectionProcessing, "ChangedDetection")
