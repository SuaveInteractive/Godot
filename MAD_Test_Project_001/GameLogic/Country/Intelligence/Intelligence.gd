extends Node
"***** This class has unit test coverage.  Refer to 'test_Intelligence.gd' *****"

enum InformationLevel {NONE = 0, LOW, MEDIUM, HIGH, TOTAL}

"One IntelEntry per Entity which will contain an dictonary of all of it's detections and the level of detection."
class IntelEntry:
	var detections : Dictionary = {}
	var highestIntelLvl = InformationLevel.NONE
	
var IntelInfoRes = load("res://ResourceDefinition/Intelligence/IntelligenceInformation.gd")

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

""" 
	Used to add intel form nodes that use the acceptedNodeTypem - i.e. 'DetectNode' 
"""
func addIntelFromDetection(detectorEntity, informationLevel, detectedEntity) -> void:
	if _validEntity(detectedEntity) == false:
		var stringError : String = "[Intelligence]: Wrong node Type passed to 'addIntelFromDetection' [" + str(detectedEntity.get_class()) + "].  Expected [" + acceptedNodeType + "]"
		push_error(stringError)
		return
		
	var parentNode = detectedEntity.get_parent()
	var detectorParentNode = null
	if detectorEntity != null:
		detectorParentNode = detectorEntity.get_parent()
	
	var intelInfo = _getIntelInfoForNode(parentNode)
	if intelInfo == null:
		intelInfo = IntelInfoRes.new()
		intelInfo.TrackingNodePath = parentNode.get_path()
		if detectorParentNode != null:
			intelInfo.DetectorNodePath = detectorParentNode.get_path()
		
	addIntel(intelInfo, informationLevel, detectorParentNode)

"""
	Add a IntelligenceInformation entry to the class checking to make sure it is not a 
	duplicate.
"""
func addIntel(intelInfo, informationLevel, detectorParentNode) -> void:
	var intelEntry = null
	if Intel.has(intelInfo):
		intelEntry = Intel[intelInfo]
		if intelEntry.detections.has(detectorParentNode) and intelEntry.detections[detectorParentNode] == informationLevel:
			return
	
	if intelEntry:
		if intelEntry.detections.has(detectorParentNode):
			if intelEntry.detections[detectorParentNode] < informationLevel:
				intelEntry.detections[detectorParentNode] = informationLevel
		else:
			intelEntry.detections[detectorParentNode] = informationLevel 
			
		if intelEntry.highestIntelLvl < informationLevel:
			intelEntry.highestIntelLvl = informationLevel
			changedIntel[intelInfo] = informationLevel
	else:
		Intel[intelInfo] = IntelEntry.new()
		Intel[intelInfo].detections[detectorParentNode] = informationLevel 
		Intel[intelInfo].highestIntelLvl = informationLevel
		changedIntel[intelInfo] = informationLevel

""" 
	Used to change intel form nodes that use the acceptedNodeTypem - i.e. 'DetectNode' 
"""
func changeIntelFromDetection(detectorEntity, informationLevel, detectedEntity) -> void:
	if _validEntity(detectedEntity) == false:
		var stringError : String = "[Intelligence]: Wrong node Type passed to 'addIntel' [" + str(detectedEntity.get_class()) + "].  Expected [" + acceptedNodeType + "]"
		push_error(stringError)
		return
		
	var parentNode = detectedEntity.get_parent()
	var detectorParentNode = null
	if detectorEntity != null:
		detectorParentNode = detectorEntity.get_parent()
	
	var intelInfo = _getIntelInfoForNode(parentNode)
	
	changeIntel(intelInfo, informationLevel, detectorParentNode)

func changeIntel(intelInfo, informationLevel, detectorParentNode) -> void:
	var intelEntry = null
	if Intel.has(intelInfo):
		intelEntry = Intel[intelInfo]
		if intelEntry.detections.has(detectorParentNode) and intelEntry.detections[detectorParentNode] == informationLevel:
			return
			
		if intelEntry.detections.has(detectorParentNode):
			if intelEntry.detections[detectorParentNode] != informationLevel:
				intelEntry.detections[detectorParentNode] = informationLevel
				
				var previousHighesDetection = intelEntry.highestIntelLvl
				intelEntry.highestIntelLvl = _getHighestIntelligenceForDetection(intelEntry.detections)
				
				if previousHighesDetection != intelEntry.highestIntelLvl:
					changedIntel[intelInfo] = intelEntry.highestIntelLvl
	
func removeDetection(detectorEntity, informationLevel, detectedEntity) -> void:
	if _validEntity(detectedEntity) == false:
		var stringError : String = "[Intelligence]: Wrong node Type passed to 'removeDetection' [" + str(detectedEntity.get_class()) + "].  Expected [" + acceptedNodeType + "]"
		push_error(stringError)
		return
	
	var intelInfo = _getIntelInfoForNode(detectedEntity.get_parent())
	if Intel.has(intelInfo):
		var intelEntry = Intel[intelInfo]
		if detectorEntity == null or informationLevel == null:
			Intel.erase(intelInfo)
			changedIntel[intelInfo] = InformationLevel.NONE
		else:
			var detectorParentNode = detectorEntity.get_parent()
			
			if intelEntry.detections.has(detectorParentNode):
				if intelEntry.detections[detectorParentNode] == informationLevel:
					intelEntry.detections.erase(detectorParentNode)
					
					var previousHighesDetection = intelEntry.highestIntelLvl
					intelEntry.highestIntelLvl = _getHighestIntelligenceForDetection(intelEntry.detections)
					
					if previousHighesDetection > intelEntry.highestIntelLvl:
						changedIntel[intelInfo] = intelEntry.highestIntelLvl
				
			if intelEntry.detections.size() < 1:
				Intel.erase(intelInfo)
			
func _getKnownIntelligence() -> Dictionary:
	return _getHighestIntelligence(Intel)
	
func getKnownTrackableIntelligence() -> Dictionary:
	var res = {}
	var highestInfo = _getHighestIntelligence(Intel)
	for info in highestInfo:
		if info.TrackingNodePath.is_empty() == false:
			res[get_node(info.TrackingNodePath)] = highestInfo[info]
	return res

func _getHighestIntelligence(var intelDict : Dictionary) -> Dictionary:
	var retHighIntel = {}
	
	for entity in intelDict:
		retHighIntel[entity] = intelDict[entity].highestIntelLvl
		
	return  retHighIntel
	
func _getIntelInfoForNode(var node : Node):
	for k in Intel:
		if k.TrackingNodePath == node.get_path():
			return k
	return null

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

"""
	Callbacks
"""
func _on_DetectionProcessing_GainedDetection(detectedEntity, detectionLevel, detector):
	var intelLvl = _convertDetectionLevelToIntelLevel(detectionLevel)
	addIntelFromDetection(detector, intelLvl, detectedEntity)

func _on_DetectionProcessing_ChangedDetection(detectedEntity, detectionLevel, detector):
	var intelLvl = _convertDetectionLevelToIntelLevel(detectionLevel)
	changeIntelFromDetection(detector, intelLvl, detectedEntity)

func _on_DetectionProcessing_LostDetection(detectedEntity, _previousDetectionLevel):
	removeDetection(null, null, detectedEntity)
