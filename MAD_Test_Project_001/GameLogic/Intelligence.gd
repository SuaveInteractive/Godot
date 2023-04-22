extends Node

enum InformationLevel {NONE, LOW, MEDIUM, HIGH, TOTAL}

var Intel : Dictionary = {}

func _ready():
	pass

func addDetection(entity) -> void:
	Intel[entity] = InformationLevel.TOTAL
	
func removeDetection(entity) -> void:
	Intel.erase(entity)

func getKnownIntelligence() -> Dictionary:
	return Intel
