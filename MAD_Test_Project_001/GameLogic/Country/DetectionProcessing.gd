extends Node

"""
	Detection Levels:
		0: TOTAL 
		1: HIGH 
		2: MEDIUM
		3: LOW
		4: NONE
"""
enum DetectionLevels {TOTAL = 0, HIGH = 1, MEDIUM = 2, LOW = 3, NONE = 4}

signal GainedDetection(detectedEntity, detectionLevel, detectorEntity)
signal ChangedDetection(detectedEntity, detectionLevel, detectorEntity)
signal LostDetection(detectedEntity)

# Emitted when an entitey has been added or removed to be processed 
signal DetectTrackingChanged()

export(float) var detectionTestTimer = 3.0

class DetectorStatus:
	var detectedAtLevel : int = DetectionLevels.NONE
	var detectionLevels = []

class DetectionStatus:
	var detectors = {}
	var detectionTimer = 0.0
	
var DetectionDic = {}
var Randomizer : RandomNumberGenerator = RandomNumberGenerator.new()

export(float) var detectionChance_TOTAL = 1.0
export(float) var detectionChance_HIGH = 0.75
export(float) var detectionChance_MEDIUM = 0.5
export(float) var detectionChance_LOW = 0.25

func _ready():
	Randomizer.randomize()
	
func _process(delta):
	for key in DetectionDic:
		var detectionStatus = DetectionDic[key]
		var currentTimer = detectionStatus.detectionTimer
		detectionStatus.detectionTimer = currentTimer - delta
		if detectionStatus.detectionTimer < 0:
			_testDetection(detectionStatus, key)		
			detectionStatus.detectionTimer = detectionTestTimer

func addDetection(detectorEntity, detectionLevel, detectedEntityNode):
	var detectionStatus : DetectionStatus = null
	if DetectionDic.has(detectedEntityNode):
		detectionStatus = DetectionDic[detectedEntityNode]
		if detectionStatus.detectors.has(detectorEntity):
			var detectorStatus = detectionStatus.detectors[detectorEntity]
			detectorStatus.detectionLevels.append(detectionLevel)
			detectorStatus.detectionLevels.sort()
		else:
			var detectorStatus = DetectorStatus.new()
			detectorStatus.detectionLevels.append(detectionLevel)
			detectionStatus.detectors[detectorEntity] = detectorStatus
	else:
		detectionStatus = DetectionStatus.new()
		var detectorStatus = DetectorStatus.new()
		detectorStatus.detectionLevels.append(detectionLevel)
		detectionStatus.detectors[detectorEntity] = detectorStatus
			
		DetectionDic[detectedEntityNode] = detectionStatus
		emit_signal("DetectTrackingChanged")
		
	_testDetection(detectionStatus, detectedEntityNode)	

func removeDetection(detectorEntity, detectionLevel, detectedEntityNode):
	if DetectionDic.has(detectedEntityNode):
		var detectionStatus = DetectionDic[detectedEntityNode]
		if detectionStatus.detectors.has(detectorEntity):
			detectionStatus.detectors.erase(detectorEntity)
		
		if detectionStatus.detectors.size() < 1:
			DetectionDic.erase(detectedEntityNode)
			emit_signal("LostDetection", detectedEntityNode)
			emit_signal("DetectTrackingChanged")

func _testDetection(var detectionStatus, var detectedEntity):
	var previousDetectionLevel = DetectionLevels.NONE
	var overallDetectionLevel = DetectionLevels.NONE
	var newDetector = null
	
	for detectorKey in detectionStatus.detectors:
		var detector = detectionStatus.detectors[detectorKey]
		if previousDetectionLevel > detector.detectedAtLevel:
			previousDetectionLevel = detector.detectedAtLevel
		
		var detectionLevel = detector.detectionLevels.front()
		var detected = _testDetectionLevel(detectionLevel)
		if detected:
			detector.detectedAtLevel = detectionLevel
			if detectionLevel < overallDetectionLevel:
				overallDetectionLevel = detectionLevel
				newDetector = detectorKey
		else:
			detector.detectedAtLevel = DetectionLevels.NONE
	
	if previousDetectionLevel != overallDetectionLevel:	
		if previousDetectionLevel == DetectionLevels.NONE:
			detectionStatus.detectionTimer = detectionTestTimer
			emit_signal("GainedDetection", detectedEntity, overallDetectionLevel, newDetector)
		elif previousDetectionLevel != overallDetectionLevel:
			if previousDetectionLevel < overallDetectionLevel:
				detectionStatus.detectionTimer = detectionTestTimer
			emit_signal("ChangedDetection", detectedEntity, overallDetectionLevel, newDetector)
		else:
			if detectionStatus.detectionTimer < 0 && previousDetectionLevel != DetectionLevels.NONE:
				detectionStatus.detectionTimer = detectionTestTimer
				emit_signal("LostDetection", detectedEntity)
			
func _testDetectionLevel(var testDetectionLevel : int) -> bool:
	var detected : bool = false
	match testDetectionLevel:
		DetectionLevels.TOTAL:
			detected = Randomizer.randf() <= detectionChance_TOTAL
		DetectionLevels.HIGH:
			detected = Randomizer.randf() <= detectionChance_HIGH
		DetectionLevels.MEDIUM:
			detected = Randomizer.randf() <= detectionChance_MEDIUM
		DetectionLevels.LOW:
			detected = Randomizer.randf() <= detectionChance_LOW
				
	return detected
