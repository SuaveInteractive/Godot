extends Node

var cityScene = load("res://GameEntities/City/City.tscn")
var submarineScene = load("res://GameEntities/Submarine/Submarine.tscn")

func _ready():
	pass
	
func _on_World_Model_WorldMapTextureUpdates(texture):
	$WorldMap.texture = texture
	
func _on_World_Model_WorldBuildingsChanged(buildings):
	for building in buildings:
		var buildingInstance = cityScene.instance()
		buildingInstance.position = building.position
		buildingInstance.z_index = 1
		buildingInstance.get_node("CitySprite").get_material().set_shader_param("colour", building.color)
		add_child(buildingInstance)
		
	_updateColours()

func _on_World_Model_WorldUnitsChanged(units):
	for unit in units:
		var unitInstance = submarineScene.instance()
		unitInstance.position = unit.position
		unitInstance.z_index = 1
		unitInstance.get_node("SubmarineSprite").get_material().set_shader_param("colour", unit.color)
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
