extends Node

"""
Documentation:
https://miro.com/app/board/uXjVPBx20R0=/ 
"""

signal WorldMapTextureUpdates(texture)
signal WorldCountriesChanged(countries)
signal WorldUnitsChanged(units)
signal WorldBuildingsChanged(buildings)
signal SelectedEntitiesChanged(selectedEntities)
signal UnselectedEntitiesChanged(unselectedEntities)

var WorldModelResource : Resource = null

var CountriesArray : Array setget , getCountries
var UnitsArray : Array
var BuildingArray : Array

var SelectedEntities : Array = []

class UnitModel:
	var position : Vector2
	var color : Color

func _ready():
	pass

func setWorldModel(worldModelRes : Resource) -> void:
	if WorldModelResource != worldModelRes:
		WorldModelResource = worldModelRes
		
		var landNavInstance : NavigationPolygonInstance = NavigationPolygonInstance.new()
		landNavInstance.name = "LandNavigation"
		landNavInstance.set_navigation_polygon(WorldModelResource.LandNavigation)

		var waterNavInstance : NavigationPolygonInstance = NavigationPolygonInstance.new()
		waterNavInstance.name = "WaterNavigation"
		waterNavInstance.set_navigation_polygon(WorldModelResource.WaterNavigation)
				
		$Navigation.add_child(landNavInstance)
		$Navigation.add_child(waterNavInstance)
		
		_updateCountry(WorldModelResource.Countries)
		_updateUnits(WorldModelResource.Units)
		_updateBuildings(WorldModelResource.Buildings)
		emit_signal("WorldMapTextureUpdates", WorldModelResource.Map)
		
func _updateCountry(countries):
	for country in countries:
		var newCountry : Country = Country.new(country.CountryName,  country.CountryColor)
		CountriesArray.append(newCountry)
		
	emit_signal("WorldCountriesChanged", WorldModelResource.Countries)
	
func _updateUnits(units):
	for unit in units:
		var unitModel = UnitModel.new()
		unitModel.position = unit.UnitPosition
		unitModel.color = getCountryColour(unit.UnitCountry)
		
		UnitsArray.append(unitModel)
					
	emit_signal("WorldUnitsChanged", UnitsArray)
	
func _updateBuildings(buildings):
	for building in buildings:
		var buildingModel = UnitModel.new()
		buildingModel.position = building.BuildingPosition
		buildingModel.color = getCountryColour(building.BuildingCountry)
		
		BuildingArray.append(buildingModel)
	
	emit_signal("WorldBuildingsChanged", BuildingArray)

func getSelectedEntities() -> Array:
	return SelectedEntities

func getSelectedUnits() -> Array:
	var selectedUnits : Array = []
	for entity in SelectedEntities:
		selectedUnits.append(entity.owner)
		
	return selectedUnits
	
func setSelectedEntities(entities : Array) -> void:
	var unselectedEnties = []
	for selectedEntity in SelectedEntities:
		var stillSelected = false
		for entity in entities:	
			if selectedEntity == entity:
				 stillSelected = true
		if not stillSelected:
			unselectedEnties.append(selectedEntity)
	
	SelectedEntities = entities
	
	emit_signal("SelectedEntitiesChanged", SelectedEntities)
	
	if unselectedEnties.size() > 0:
		emit_signal("UnselectedEntitiesChanged", unselectedEnties)		
		
func getCountries():
	return CountriesArray

func getNavPolygon() -> Navigation2D:
	return $Navigation as Navigation2D

"""
HELPER FUNCTIONS
"""
func getCountryColour(countryName : String) -> Color:
	for country in CountriesArray:
		if country.name == countryName:
			return country.get_colour()
	return Color(255)
