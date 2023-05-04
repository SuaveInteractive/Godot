extends Node

signal WorldEntitySelected(country, entity)

func _on_World_Model_WorldEntitySelected(country, entity):
	emit_signal("WorldEntitySelected", country, entity)

func setIntelligenceInterface(var intelligence):
	intelligence.connect("IntelligenceChanged", self, "OnIntelligenceChanged")
	
	var intel : Dictionary = intelligence.getKnownIntelligence()
	var countries = $"World Controller/World Model/Countries"
	for country in countries.get_children():
		for unit in country.get_node("Units").get_children():
			if intel.has(unit):
				var intelLevel = intel[unit]
				_setObfuscationLevel(unit, intelLevel)
			else:
				unit.get_node("EntityObfuscation").setObfuscationHigh()
				
		for building in country.get_node("Buildings").get_children():
			if intel.has(building):
				var intelLevel = intel[building]
				_setObfuscationLevel(building, intelLevel)
			else:
				building.get_node("EntityObfuscation").setObfuscationHigh()
				
func disconnectIntelligenceInterface(var intelligence):
	intelligence.disconnect("IntelligenceChanged", self, "OnIntelligenceChanged")

func OnIntelligenceChanged(changedIntel):
	var countries = $"World Controller/World Model/Countries"
	for country in countries.get_children():
		for unit in country.get_node("Units").get_children():
			if changedIntel.has(unit):
				var intelLevel = changedIntel[unit]
				_setObfuscationLevel(unit, intelLevel)
				
		for building in country.get_node("Buildings").get_children():
			if changedIntel.has(building):
				var intelLevel = changedIntel[building]
				_setObfuscationLevel(building, intelLevel)
					
func _setObfuscationLevel(entity, intelLevel) -> void:
	match intelLevel:
		0: # Intel Level None
			entity.get_node("EntityObfuscation").setObfuscationHigh()
		1: # Intel Level Low
			entity.get_node("EntityObfuscation").setObfuscationMedium()
		2: # Intel Level Medium
			entity.get_node("EntityObfuscation").setObfuscationLow()
		3: # Intel Level High
			entity.get_node("EntityObfuscation").setObfuscationNone()
		4: # Intel Level Total
			entity.get_node("EntityObfuscation").setObfuscationNone()
