extends Node

enum InformationLevel {NONE, LOW, MEDIUM, HIGH, TOTAL}

var Intel : Dictionary = {}
var changedIntel : Dictionary = {}

signal IntelligenceChanged(changedIntellegence)

func _ready():
	pass
	
func _process(_delta):
	if !changedIntel.empty():
		emit_signal("IntelligenceChanged", changedIntel)
		changedIntel.clear()

func addDetection(entity) -> void:
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
		Intel.erase(parentNode)

func getKnownIntelligence() -> Dictionary:
	return Intel
