extends Node

var cityScene = load("res://GameEntities/City/City.tscn")
var siloScene = load("res://GameEntities/Silo/Silo.tscn")
var submarineScene = load("res://GameEntities/Submarine/Submarine.tscn")

signal UnitSelected(unit)

func _ready():
	pass
	
func _on_World_Model_WorldMapTextureUpdates(texture):
	$WorldMap.texture = texture
	
func _on_World_Model_WorldBuildingChanged(building):
	var buildingInstance = null 
	if building.type == "silo":
		buildingInstance = siloScene.instance()
	else:
		buildingInstance = cityScene.instance()
	
	buildingInstance.position = building.position
	buildingInstance.z_index = 1
	if buildingInstance.has_node("CitySprite"):
		buildingInstance.get_node("CitySprite").get_material().set_shader_param("colour", building.color)
	add_child(buildingInstance)

func _on_World_Model_WorldUnitsChanged(units):
	for unit in units:
		var unitInstance = submarineScene.instance()
		unitInstance.position = unit.position
		unitInstance.z_index = 1
		unitInstance.get_node("SubmarineSprite").get_material().set_shader_param("colour", unit.color)
		
		unitInstance.get_node("Selection").connect("EntitySelected", self, "OnUnitSelected")
		
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
