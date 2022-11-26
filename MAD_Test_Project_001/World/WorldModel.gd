extends Node

"""
Documentation:
https://miro.com/app/board/uXjVPBx20R0=/ 
"""

signal WorldMapTextureUpdates(texture)
signal WorldCountriesChanged(countries)
signal WorldUnitsChanged(units)
signal WorldBuildingsChanged(buildings)

var WorldModelResource : Resource = null

var CountryColourDict : Dictionary
var CountryUnitsArray : Array
var CountryBuildingArray : Array

class UnitModel:
	var position : Vector2
	var color : Color

func _ready():
	pass

func setWorldModel(worldModelRes : Resource) -> void:
	if WorldModelResource != worldModelRes:
		WorldModelResource = worldModelRes
		
		_updateCountry(WorldModelResource.Countries)
		_updateUnits(WorldModelResource.Units)
		_updateBuildings(WorldModelResource.Buildings)
		emit_signal("WorldMapTextureUpdates", WorldModelResource.Map)
		
func _updateCountry(countries):
	for country in countries:
		CountryColourDict[country.CountryName] = country.CountryColor
		
	emit_signal("WorldCountriesChanged", WorldModelResource.Countries)
	
func _updateUnits(units):
	for unit in units:
		var unitModel = UnitModel.new()
		unitModel.position = unit.UnitPosition
		unitModel.color = CountryColourDict[unit.UnitCountry]
		
		CountryUnitsArray.append(unitModel)
					
	emit_signal("WorldUnitsChanged", CountryUnitsArray)
	
func _updateBuildings(buildings):
	for building in buildings:
		var buildingModel = UnitModel.new()
		buildingModel.position = building.BuildingPosition
		buildingModel.color = CountryColourDict[building.BuildingCountry]
		
		CountryBuildingArray.append(buildingModel)
	
	emit_signal("WorldBuildingsChanged", CountryBuildingArray)
