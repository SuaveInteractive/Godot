extends Node

signal WorldEntitySelected(country, entity)

func _on_World_Model_WorldEntitySelected(country, entity):
	emit_signal("WorldEntitySelected", country, entity)

func setIntelligenceInterface(var intelligence):
	intelligence.connect("IntelligenceChanged", self, "OnIntelligenceChanged")
	
	var intel : Dictionary = intelligence.getKnownTrackableIntelligence()
	var countries = $"World Controller/World Model/Countries"
	for country in countries.get_children():
		for unit in country.get_node("Units").get_children():
			if intel.has(unit):
				var intelLevel = intel[unit]
				_setObfuscationLevel(unit, intelLevel)
			else:
				unit.get_node("EntityObfuscation").setObfuscationTotal()
				
		for building in country.get_node("Buildings").get_children():
			if intel.has(building):
				var intelLevel = intel[building]
				_setObfuscationLevel(building, intelLevel)
			else:
				building.get_node("EntityObfuscation").setObfuscationHigh()
				
func disconnectIntelligenceInterface(var intelligence):
	intelligence.disconnect("IntelligenceChanged", self, "OnIntelligenceChanged")

func OnIntelligenceChanged(var changedIntel : Dictionary) -> void:
	var countries = $"World Controller/World Model/Countries"
	for country in countries.get_children():
		
		for intelInfo in changedIntel:
			if intelInfo.TrackingNodePath != null:
				var node = get_node(intelInfo.TrackingNodePath)
				if country.get_node("Units").get_children().has(node):
					var intelLevel = changedIntel[intelInfo]
					_setObfuscationLevel(node, intelLevel)
					
				if country.get_node("Buildings").get_children().has(node):
					var intelLevel = changedIntel[intelInfo]
					_setObfuscationLevel(node, intelLevel)
			
#		for unit in country.get_node("Units").get_children():
#			if changedIntel.has(unit):
#				var intelLevel = changedIntel[unit]
#				_setObfuscationLevel(unit, intelLevel)
#
#		for building in country.get_node("Buildings").get_children():
#			if changedIntel.has(building):
#				var intelLevel = changedIntel[building]
#				_setObfuscationLevel(building, intelLevel)
					
func _setObfuscationLevel(entity, intelLevel) -> void:
	match intelLevel:
		0: # Intel Level None
			entity.get_node("EntityObfuscation").setObfuscationTotal()
		1: # Intel Level Low
			entity.get_node("EntityObfuscation").setObfuscationHigh()
		2: # Intel Level Medium
			entity.get_node("EntityObfuscation").setObfuscationMedium()
		3: # Intel Level High
			entity.get_node("EntityObfuscation").setObfuscationLow()
		4: # Intel Level Total
			entity.get_node("EntityObfuscation").setObfuscationNone()
