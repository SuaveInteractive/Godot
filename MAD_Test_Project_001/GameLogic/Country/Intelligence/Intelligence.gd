extends Node
"***** This class has unit test coverage.  Refer to 'test_Intelligence.gd' *****"

enum InformationLevel {NONE = 0, LOW, MEDIUM, HIGH, TOTAL}

"One IntelEntry per Entity which will contain an dictonary of all of it's detections and the level of detection."
class IntelEntry:
	var detections : Dictionary = {}
	var highestIntelLvl = InformationLevel.NONE

var Intel : Dictionary = {}
var changedIntel : Dictionary = {}

const acceptedNodeType : String = "DetectNode"

signal IntelligenceChanged(changedIntellegence)

func _ready():
	pass
	
func _process(_delta):
	if !changedIntel.empty():
		var parameters = changedIntel.duplicate(true)
		changedIntel.clear()
		emit_signal("IntelligenceChanged", parameters)
			
func addIntel(detectorEntity, informationLevel, detectedEntity) -> void:
	if _validEntity(detectedEntity) == false:
		var stringError : String = "[Intelligence]: Wrong node Type passed to 'addIntel' [" + str(detectedEntity.get_class()) + "].  Expected [" + acceptedNodeType + "]"
		push_error(stringError)
		return
	
	var parentNode = detectedEntity.get_parent()
	var detectorParentNode = null
	if detectorEntity != null:
		detectorParentNode = detectorEntity.get_parent()
	
	if Intel.has(parentNode):
		var intelEntry = Intel[parentNode]
		if intelEntry.detections.has(detectorParentNode) and intelEntry.detections[detectorParentNode] == informationLevel:
			return
	
	if Intel.has(parentNode):
		if Intel[parentNode].detections.has(detectorParentNode):
			if Intel[parentNode].detections[detectorParentNode] < informationLevel:
				Intel[parentNode].detections[detectorParentNode] = informationLevel
		else:
			Intel[parentNode].detections[detectorParentNode] = informationLevel 
			
		if Intel[parentNode].highestIntelLvl < informationLevel:
			Intel[parentNode].highestIntelLvl = informationLevel
			changedIntel[parentNode] = informationLevel
	else:
		Intel[parentNode] = IntelEntry.new()
		Intel[parentNode].detections[detectorParentNode] = informationLevel 
		Intel[parentNode].highestIntelLvl = informationLevel
		changedIntel[parentNode] = informationLevel
	
func removeDetection(detectorEntity, informationLevel, detectedEntity) -> void:
	if _validEntity(detectedEntity) == false:
		var stringError : String = "[Intelligence]: Wrong node Type passed to 'removeDetection' [" + str(detectedEntity.get_class()) + "].  Expected [" + acceptedNodeType + "]"
		push_error(stringError)
		return
		
	var detectedParentNode = detectedEntity.get_parent()
	if Intel.has(detectedParentNode):				
		if detectorEntity == null or informationLevel == null:
			Intel.erase(detectedParentNode)
			changedIntel[detectedParentNode] = InformationLevel.NONE
		else:
			var detectorParentNode = detectorEntity.get_parent()
			
			if Intel[detectedParentNode].detections.has(detectorParentNode):
				if Intel[detectedParentNode].detections[detectorParentNode] == informationLevel:
					Intel[detectedParentNode].detections.erase(detectorParentNode)
					
					var previousHighesDetection = Intel[detectedParentNode].highestIntelLvl
					Intel[detectedParentNode].highestIntelLvl = _getHighestIntelligenceForDetection(Intel[detectedParentNode].detections)
					
					if previousHighesDetection > Intel[detectedParentNode].highestIntelLvl:
						changedIntel[detectedParentNode] = Intel[detectedParentNode].highestIntelLvl
				
			if Intel[detectedParentNode].detections.size() < 1:
				Intel.erase(detectedParentNode)
			
func getKnownIntelligence() -> Dictionary:			
	return _getHighestIntelligence(Intel)

func _getHighestIntelligence(var intelDict : Dictionary) -> Dictionary:
	var retHighIntel = {}
	
	for entity in intelDict:
		retHighIntel[entity] = intelDict[entity].highestIntelLvl
		
	return  retHighIntel

func _getHighestIntelligenceForDetection(var detections : Dictionary) -> int:
	var highestDetectionLevel = InformationLevel.NONE 
	for detector in detections:
		if detections[detector] > highestDetectionLevel:
			highestDetectionLevel = detections[detector]
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
	addIntel(detector, intelLvl, detectedEntity)

func _on_DetectionProcessing_ChangedDetection(detectedEntity, detectionLevel, detector):
	var intelLvl = _convertDetectionLevelToIntelLevel(detectionLevel)
	addIntel(detector, intelLvl, detectedEntity)

func _on_DetectionProcessing_LostDetection(detectedEntity, previousDetectionLevel):
	removeDetection(null, null, detectedEntity)
