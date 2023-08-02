extends Node

enum InformationLevel {NONE = 0, LOW, MEDIUM, HIGH, TOTAL}

class Detection:
	var detector : Node = null
	var detectionLevel = InformationLevel.TOTAL
	
class IntelEntry:
	var detections : Array = []
	var highestIntelLvl = InformationLevel.NONE

var Intel : Dictionary = {}
var changedIntel : Dictionary = {}

const acceptedNodeType : String = "DetectNode"

signal IntelligenceChanged(changedIntellegence)

func _ready():
	pass
	
func _process(_delta):
	if !changedIntel.empty():
		var highestIntel : Dictionary = _getHighestIntelligence(changedIntel)
		changedIntel.clear()
		for highestEntityIntel in highestIntel:
			if Intel[highestEntityIntel].highestIntelLvl < highestIntel[highestEntityIntel]:
				Intel[highestEntityIntel].highestIntelLvl = highestIntel[highestEntityIntel]
				emit_signal("IntelligenceChanged", highestIntel)
		

func addIntel(detectorEntity, informationLevel, detectedEntity) -> void:
	if _validEntity(detectedEntity) == false:
		var stringError : String = "[Intelligence]: Wrong node Type passed to 'addIntel' [" + str(detectedEntity.get_class()) + "].  Expected [" + acceptedNodeType + "]"
		push_error(stringError)
		return
	
	var parentNode = detectedEntity.get_parent()
	var detectorNode = null
	if detectorEntity != null:
		detectorNode = detectorEntity.get_parent()
	
	if Intel.has(parentNode):
		for detec in Intel[parentNode].detections:
			if detec.detector == detectorNode and detec.detectionLevel == informationLevel:
				return
		
	var newDetection = Detection.new()
	newDetection.detector = detectorNode
	newDetection.detectionLevel = informationLevel
	
	if Intel.has(parentNode):
		Intel[parentNode].detections.append(newDetection)
	else:
		Intel[parentNode] = IntelEntry.new()
		Intel[parentNode].detections.append(newDetection)
		
	changedIntel[parentNode] = []
	changedIntel[parentNode].append(newDetection)
	
func removeDetection(detectorEntity, detectedEntity) -> void:
	var detectedParentNode = detectedEntity.get_parent()
	if Intel.has(detectedParentNode):		
		var intelEntries = Intel[detectedParentNode].detections
		for intelEntry in intelEntries:
			var detectorParentNode = detectorEntity.get_parent()
			if intelEntry.detector == detectorParentNode:
				var previousHighesDetection = _getHighestIntelligenceForDetection(intelEntries)
				intelEntry.detectionLevel = InformationLevel.NONE
				var newHighesDetection = _getHighestIntelligenceForDetection(intelEntries)
				
				if previousHighesDetection > newHighesDetection:
					if changedIntel.has(detectedParentNode):
						changedIntel[detectedParentNode].append(intelEntry)
					else:
						changedIntel[detectedParentNode] = []
						changedIntel[detectedParentNode].append(intelEntry)
				
				intelEntries.erase(intelEntry)
				break

func getKnownIntelligence() -> Dictionary:	
	var param = {}
	for k in Intel:
		param[k] = Intel[k].detections
		
	return _getHighestIntelligence(param)

func _getHighestIntelligence(var intelDict : Dictionary) -> Dictionary:
	var retHighIntel = {}
	
	for entity in intelDict:
		retHighIntel[entity] = _getHighestIntelligenceForDetection(intelDict[entity])
		
	return  retHighIntel

func _getHighestIntelligenceForDetection(var detections : Array) -> int:
	var highestDetectionLevel = InformationLevel.NONE 
	for detection in detections:
		if detection.detectionLevel > highestDetectionLevel:
			highestDetectionLevel = detection.detectionLevel
	return highestDetectionLevel

func _validEntity(var entity : Node) -> bool:
	return entity.get_class() == acceptedNodeType
	
func _convertDetectionLevelToIntelLevel(var detectionLevel) -> int:
	match (detectionLevel):
		0: 
			return InformationLevel.TOTAL
		1: 	
			return InformationLevel.HIGH
		2:
			return InformationLevel.MEDIUM
		3: 
			return InformationLevel.LOW
		4:
			return InformationLevel.NONE
			
	return InformationLevel.NONE

func _on_DetectionProcessing_GainedDetection(detectedEntity, detectionLevel, detector):
	var intelLvl = _convertDetectionLevelToIntelLevel(detectionLevel)
	addIntel(detector, _convertDetectionLevelToIntelLevel(intelLvl), detectedEntity)

func _on_DetectionProcessing_ChangedDetection(detectedEntity, detectionLevel, detector):
	var intelLvl = _convertDetectionLevelToIntelLevel(detectionLevel)
	addIntel(detector, _convertDetectionLevelToIntelLevel(intelLvl), detectedEntity)

func _on_DetectionProcessing_LostDetection(_detectedEntity):
	pass # Replace with function body.
