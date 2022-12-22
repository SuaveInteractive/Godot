extends Node

var cityScene = load("res://GameEntities/City/City.tscn")
var siloScene = load("res://GameEntities/Silo/Silo.tscn")
var submarineScene = load("res://GameEntities/Submarine/Submarine.tscn")
var targetScene = load("res://GameEntities/Target/Target.tscn")
var missileScene = load("res://GameEntities/Missile/Missile.tscn")

signal UnitSelected(unit)

func _ready():
	pass
	
func _on_World_Model_WorldMapTextureUpdates(texture):
	$WorldMap.texture = texture
	
func _on_World_Model_WorldBuildingChanged(building):
	var buildingInstance = null 
	if building.type == "Silo":
		buildingInstance = siloScene.instance()
	else:
		buildingInstance = cityScene.instance()
	
	buildingInstance.position = building.position
	buildingInstance.z_index = 1
	buildingInstance.set_name("building")
	add_child(buildingInstance)
	
	if buildingInstance.has_node("Selection"):
		buildingInstance.get_node("Selection").connect("EntitySelected", self, "OnUnitSelected")
	
	if buildingInstance.has_node("CitySprite"):
		buildingInstance.get_node("CitySprite").get_material().set_shader_param("colour", building.color)

func _on_World_Model_WorldUnitsChanged(units):
	for unit in units:
		var unitInstance = submarineScene.instance()
		unit.node = unitInstance
		unit.instanceID = unitInstance.get_instance_id ()
		
		unitInstance.position = unit.position
		unitInstance.z_index = 1
		unitInstance.get_node("SubmarineSprite").get_material().set_shader_param("colour", unit.color)
		
		unitInstance.get_node("Selection").connect("EntitySelected", self, "OnUnitSelected")
		
		unitInstance.set_name("unit")
		add_child(unitInstance)
		
	_updateColours()
	
func _on_World_Model_WorldCountriesChanged(countries):
	#for country in countries:
	#	CountryColourDict[country.CountryName] = country.CountryColor
	#_updateColours()
	pass

func _updateColours():
	for child in get_children():
		pass
		#child.get_material().set_shader_param("colour", country.CountryColour)
		
func OnUnitSelected(unit) -> void:
	emit_signal("UnitSelected", unit)

func _on_World_Model_SelectedEntitiesChanged(selectedEntities):
	for entity in selectedEntities:
		entity.setSelected(true)
	
func _on_World_Model_UnselectedEntitiesChanged(unselectedEntities):
	for entity in unselectedEntities:
		entity.setSelected(false)

func _on_World_Model_TargetAdded(instanceID, position):
	for child in get_children():
		if child.get_instance_id() == instanceID:
			var targetInstance = targetScene.instance()
			targetInstance.position = position
			targetInstance.set_name("target")
			
			var targetNode = child.get_node("TargetNode")
			if targetNode != null:
				targetNode.add_child(targetInstance)
			else:
				child.add_child(targetInstance)

func _on_World_Model_WorldMissilesChanged(missiles):
	for missile in missiles:
		var missileInstance = missileScene.instance()
		missileInstance.set_name("missile")
		missileInstance.setTarget(missile.target)
		missileInstance.position = missile.source
		add_child(missileInstance)
