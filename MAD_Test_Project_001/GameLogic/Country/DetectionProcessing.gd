extends Node

"""
	Detection Levels:
		-1: None
		0: TOTAL 
		1: HIGH 
		2: MEDIUM
		3: LOW
"""
enum DetectionLevels {NONE = -1, TOTAL = 0, HIGH = 1, MEDIUM = 2, LOW = 3}

signal GainedDetection(entity, detectionLevel)
signal ChangedDetection(entity, detectionLevel)
signal LostDetection(entity)

# Emitted when an entitey has been added or removed to be processed 
signal DetectTrackingChanged()

export(float) var detectionTestTimer = 3.0

class DetectionStatus:
	var detectedAtLevel : int = DetectionLevels.NONE
	var detectionLevels = []
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

func addDetection(detectorEntity, detectionLevel, entityDetectorNode):
	var detectionStatus : DetectionStatus = null
	if DetectionDic.has(entityDetectorNode):
		detectionStatus = DetectionDic[entityDetectorNode]
		detectionStatus.detectionLevels.append(detectionLevel)
		detectionStatus.detectionLevels.sort()
	else:
		detectionStatus = DetectionStatus.new()
		detectionStatus.detectionLevels.append(detectionLevel)
		
		DetectionDic[entityDetectorNode] = detectionStatus
		emit_signal("DetectTrackingChanged")
		
	_testDetection(detectionStatus, entityDetectorNode)	

func removeDetection(detectorEntity, detectionLevel, entityDetectorNode):
	if DetectionDic.has(entityDetectorNode):
		var detectionStatus = DetectionDic[entityDetectorNode]
		detectionStatus.detectionLevels.erase(detectionLevel)
		
		if detectionStatus.detectionLevels.size() < 1:
			DetectionDic.erase(entityDetectorNode)
			emit_signal("LostDetection")
			emit_signal("DetectTrackingChanged")

func _testDetection(var detectionStatus, var entity):
	var previousDetectionLevel = detectionStatus.detectedAtLevel
	var highestPossibleDetectionLevel = detectionStatus.detectionLevels.front()
	var detected = _testDetectionLevel(highestPossibleDetectionLevel)
	if detected:
		if previousDetectionLevel == DetectionLevels.NONE:
			detectionStatus.detectionTimer = detectionTestTimer
			emit_signal("GainedDetection", entity, highestPossibleDetectionLevel)
		elif previousDetectionLevel != highestPossibleDetectionLevel:
			if highestPossibleDetectionLevel < previousDetectionLevel:
				detectionStatus.detectionTimer = detectionTestTimer
			emit_signal("ChangedDetection", entity, highestPossibleDetectionLevel)
		detectionStatus.detectedAtLevel = highestPossibleDetectionLevel
	else:
		if detectionStatus.detectionTimer < 0 && previousDetectionLevel != DetectionLevels.NONE:
			detectionStatus.detectionTimer = detectionTestTimer
			detectionStatus.detectedAtLevel = DetectionLevels.NONE
			emit_signal("LostDetection", entity)
			
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
