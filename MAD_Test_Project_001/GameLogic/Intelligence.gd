extends Node

enum InformationLevel {NONE, LOW, MEDIUM, HIGH, TOTAL}

var Intel : Dictionary = {}
var changedIntel : Dictionary = {}

const acceptedNodeType : String = "DetectNode"

signal IntelligenceChanged(changedIntellegence)

func _ready():
	pass
	
func _process(_delta):
	if !changedIntel.empty():
		emit_signal("IntelligenceChanged", changedIntel)
		changedIntel.clear()

func addDetection(entity) -> void:
	if _validEntity(entity) == false:
		var stringError : String = "[Intelligence]: Wrong node Type passed to 'addDetection' [" + str(entity.get_class()) + "].  Expected [" + acceptedNodeType + "]"
		push_error(stringError)
		return
	
	var parentNode = entity.get_parent()
	if Intel.has(parentNode):
		pass #update current intelligence
	else:
		Intel[parentNode] = InformationLevel.TOTAL
		changedIntel[parentNode] = InformationLevel.TOTAL
	
func removeDetection(entity) -> void:
	var parentNode = entity.get_parent()
	if Intel.has(parentNode):
		changedIntel[parentNode] = InformationLevel.NONE
		var err = Intel.erase(parentNode)
		if err == false:
			var stringError : String = "[Intelligence]: Could not find key to erase [" + str(parentNode) + "]"
			push_error(stringError)

func getKnownIntelligence() -> Dictionary:
	return Intel
	
func _validEntity(var entity : Node) -> bool:
	return entity.get_class() == acceptedNodeType
