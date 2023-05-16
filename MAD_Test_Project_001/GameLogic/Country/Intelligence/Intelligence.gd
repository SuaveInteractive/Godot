extends Node

enum InformationLevel {NONE, LOW, MEDIUM, HIGH, TOTAL}

class Detection:
	var detector : Node = null
	var detectionLevel = InformationLevel.TOTAL

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
		if !highestIntel.empty():
			emit_signal("IntelligenceChanged", highestIntel)
		

func addDetection(detectorEntity, detectedEntity) -> void:
	if _validEntity(detectedEntity) == false:
		var stringError : String = "[Intelligence]: Wrong node Type passed to 'addDetection' [" + str(detectedEntity.get_class()) + "].  Expected [" + acceptedNodeType + "]"
		push_error(stringError)
		return
		
	var newDetection = Detection.new()
	if detectorEntity != null:
		newDetection.detector = detectorEntity.get_parent()
	newDetection.detectionLevel = InformationLevel.TOTAL 
	
	var parentNode = detectedEntity.get_parent()
	if Intel.has(parentNode):
		Intel[parentNode].append(newDetection)
	else:
		Intel[parentNode] = []
		Intel[parentNode].append(newDetection)
		
		changedIntel[parentNode] = []
		changedIntel[parentNode].append(newDetection)
	
func removeDetection(detectorEntity, detectedEntity) -> void:
	var detectedParentNode = detectedEntity.get_parent()
	if Intel.has(detectedParentNode):		
		var intelEntries = Intel[detectedParentNode]
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
	return _getHighestIntelligence(Intel)

func _getHighestIntelligence(var intel : Dictionary) -> Dictionary:
	var retHighIntel = {}
	
	for entity in intel:
		var highestDetectionLevel = InformationLevel.NONE 
		for detection in intel[entity]:
			retHighIntel[entity] = _getHighestIntelligenceForDetection(intel[entity])
		
	return  retHighIntel

func _getHighestIntelligenceForDetection(var detections : Array) -> int:
	var highestDetectionLevel = InformationLevel.NONE 
	for detection in detections:
		if detection.detectionLevel > highestDetectionLevel:
			highestDetectionLevel = detection.detectionLevel
	return highestDetectionLevel

func _validEntity(var entity : Node) -> bool:
	return entity.get_class() == acceptedNodeType
