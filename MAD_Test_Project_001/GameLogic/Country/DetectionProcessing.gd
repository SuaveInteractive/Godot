"***** This class has unit test coverage.  Refer to 'test_DetectionProcessing.gd' *****"

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
signal LostDetection(detectedEntity, previousDetectionLevel)

export(float) var detectionTestTimer = 3.0

"One detection status per entity.  An entity can hae multiple detectors which all have their own test."
class DetectionStatus:
	var detectors = {} 			# Entities that could detect the entity.  See DetectorStatus
	var detectedAtLevel : int = DetectionLevels.NONE # Not NONE if the entity is not detected
	var detectionTimer = 0.0

"A Detector might be detecting an entity at various levels."
class DetectorStatus:
	var detectionLevels = []
	
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
	if typeof(detectorEntity) != TYPE_OBJECT:
		var stringError : String = "[DetectionProcessing:addDetection]: 'detectorEntity' must be the Object that has detected another Object"
		push_error(stringError) 
		return
	if typeof(detectionLevel) != TYPE_INT:
		var stringError : String = "[DetectionProcessing:addDetection]: 'detectionLevel' must be an int - specifically the an int from the DetectionLevels enum"
		push_error(stringError) 
		return
	if typeof(detectedEntityNode) != TYPE_OBJECT:
		var stringError : String = "[DetectionProcessing:addDetection]: 'detectedEntityNode' must be the Object that was detected by another Object"
		push_error(stringError) 
		return
		
	var detectionStatus : DetectionStatus = null
	if DetectionDic.has(detectedEntityNode):
		detectionStatus = DetectionDic[detectedEntityNode]
		if detectionStatus.detectors.has(detectorEntity):
			var detectorStatus = detectionStatus.detectors[detectorEntity]
			detectorStatus.detectionLevels.append(detectionLevel)
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
		
	_testDetection(detectionStatus, detectedEntityNode)	

func removeDetection(detectorEntity, detectionLevel, detectedEntityNode):
	if typeof(detectorEntity) != TYPE_OBJECT:
		var stringError : String = "[DetectionProcessing:removeDetection]: 'detectorEntity' must be the Object that has detected another Object"
		push_error(stringError) 
		return
	if typeof(detectionLevel) != TYPE_INT:
		var stringError : String = "[DetectionProcessing:removeDetection]: 'detectionLevel' must be an int - specifically the an int from the DetectionLevels enum"
		push_error(stringError) 
		return
	if typeof(detectedEntityNode) != TYPE_OBJECT:
		var stringError : String = "[DetectionProcessing:removeDetection]: 'detectedEntityNode' must be the Object that was detected by another Object"
		push_error(stringError) 
		return
		
	var changed : bool = false
		
	if DetectionDic.has(detectedEntityNode):
		var detectionStatus = DetectionDic[detectedEntityNode]
		if detectionStatus.detectors.has(detectorEntity):
			if detectionStatus.detectors[detectorEntity].detectionLevels.has(detectionLevel):
				changed = true
				detectionStatus.detectors[detectorEntity].detectionLevels.erase(detectionLevel)
				if detectionStatus.detectors[detectorEntity].detectionLevels.size() < 1:
					detectionStatus.detectors.erase(detectorEntity)
					
		if detectionStatus.detectors.size() < 1:
			DetectionDic.erase(detectedEntityNode)
			emit_signal("LostDetection", detectedEntityNode, detectionLevel)
		elif changed == true:
			var ret = _getHighestDetectionLevel(detectionStatus.detectors)
			detectionStatus.detectionTimer = detectionTestTimer
			if detectionLevel != ret[0] or detectorEntity != ret[1]:
				emit_signal("ChangedDetection", detectedEntityNode, ret[0], ret[1])

func _getHighestDetectionLevel(var detectors : Dictionary) -> Array:
	var ret : Array = [DetectionLevels.NONE, null]
	
	for k in detectors:
		for level in detectors[k].detectionLevels:
			if level < ret[0]:
				ret[0] = level
				ret[1] = k
				
	return ret

func _testDetection(var detectionStatus, var detectedEntity):
	var overallDetectionLevel = DetectionLevels.NONE
	var newDetector = null
			
	for detectorKey in detectionStatus.detectors:
		var detector = detectionStatus.detectors[detectorKey]
		var newDetectionLevel = _testDectectionLevels(detector.detectionLevels)
		
		if newDetectionLevel < overallDetectionLevel:
			overallDetectionLevel = newDetectionLevel
			newDetector = detectorKey
	
	if detectionStatus.detectedAtLevel != overallDetectionLevel:	
		if detectionStatus.detectedAtLevel == DetectionLevels.NONE:
			detectionStatus.detectionTimer = detectionTestTimer
			emit_signal("GainedDetection", detectedEntity, overallDetectionLevel, newDetector)
		elif overallDetectionLevel == DetectionLevels.NONE:
			emit_signal("LostDetection", detectedEntity, detectionStatus.detectedAtLevel)
		elif detectionStatus.detectedAtLevel != overallDetectionLevel:
			if detectionStatus.detectedAtLevel > overallDetectionLevel:
				detectionStatus.detectionTimer = detectionTestTimer
			emit_signal("ChangedDetection", detectedEntity, overallDetectionLevel, newDetector)
		
		detectionStatus.detectedAtLevel = overallDetectionLevel
				
func _testDectectionLevels(var detectionLevels : Array) -> int:
	var detectedLevel = DetectionLevels.NONE
	var randVal = Randomizer.randf()
	
	for level in detectionLevels:
		if _testDetectionLevel(level, randVal):
			if detectedLevel > level:
				detectedLevel = level
			
	return detectedLevel
			
func _testDetectionLevel(var testDetectionLevel : int, var randVal : float) -> bool:
	var detected : bool = false
	match testDetectionLevel:
		DetectionLevels.TOTAL:
			detected = randVal <= detectionChance_TOTAL
		DetectionLevels.HIGH:
			detected = randVal <= detectionChance_HIGH
		DetectionLevels.MEDIUM:
			detected = randVal <= detectionChance_MEDIUM
		DetectionLevels.LOW:
			detected = randVal <= detectionChance_LOW
				
	return detected
