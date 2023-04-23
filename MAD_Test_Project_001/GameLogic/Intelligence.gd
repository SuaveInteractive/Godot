extends Node

enum InformationLevel {NONE, LOW, MEDIUM, HIGH, TOTAL}

var Intel : Dictionary = {}
var newIntel : Dictionary = {}

signal intelligenceChanged(changedIntellegence)

func _ready():
	pass
	
func _process(_delta):
	if !newIntel.empty():
		emit_signal("intelligenceChanged", newIntel)
		newIntel.clear()

func addDetection(entity) -> void:
	if Intel.has(Intel):
		pass #update current intelligence
	else:
		Intel[entity] = InformationLevel.TOTAL
		newIntel["entity"] = entity
		newIntel["InformationLevel"] = InformationLevel.TOTAL
	
func removeDetection(entity) -> void:
	Intel.erase(entity)

func getKnownIntelligence() -> Dictionary:
	return Intel
