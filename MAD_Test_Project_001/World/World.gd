extends Node

signal WorldEntitySelected(country, entity)

func _on_World_Model_WorldEntitySelected(country, entity):
	emit_signal("WorldEntitySelected", country, entity)

func setIntelligenceInterface(var _intelligence):
	pass
