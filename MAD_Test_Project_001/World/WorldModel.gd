extends Node

"""
Documentation:
https://miro.com/app/board/uXjVPBx20R0=/ 
"""

signal WorldMapTextureUpdates(texture)

signal SelectedEntitiesChanged(selectedEntities)
signal UnselectedEntitiesChanged(unselectedEntities)

var WorldModelResource : Resource = null
var WorldView : Node = null

var SelectedEntities : Array = []

class TargetorTargets:
	var targetor : Node
	var targets : Array
	
func _ready():
	WorldView = get_node("World View")
	
func _init():
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
		var newCountry : Country = Country.new(country.CountryName,  country.CountryColor, country.CountryBoarder)
		$Countries.add_child(newCountry)
	
func _updateUnits(units):
	for unit in units:
		WorldView.addUnit(unit, getCountryColour(unit.UnitCountry))
	
func _updateBuildings(buildings):
	for building in buildings:
		addBuilding(building.BuildingType, building.BuildingPosition, building.BuildingCountry)
	
func addBuilding(buildingType, buildingPosition, buildingCountry):
	WorldView.addBuilding(buildingType, buildingPosition, getCountryColour(buildingCountry))
		
func addTarget(selectedUnit, targetPos):
	WorldView.addTarget(selectedUnit, targetPos)
		
func getTargets() -> Array:
	var targets : Array 
	
	var units = WorldView.getUnits()
	for unit in units:
		targets.append_array(_getNodeTargets(unit))
	
	for building in WorldView.getBuildings():
		targets.append_array(_getNodeTargets(building))
		
	return targets
	
func _getNodeTargets(node) -> Array:
	var targets : Array
	
	var targetorTargets = TargetorTargets.new()
	targetorTargets.targetor = node
		
	if node.has_node("TargetNode"):
		for target in node.get_node("TargetNode").get_children():
			targetorTargets.targets.append(target.position)
			
	if targetorTargets.targets.size() > 0:
		targets.append(targetorTargets)
	
	return targets
			
func launchMissile(source, target):
	WorldView.addMissile(source, target)

"""
	Selection Helpers
"""
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
	
	if SelectedEntities.size() > 0:
		emit_signal("SelectedEntitiesChanged", SelectedEntities)
	
	if unselectedEnties.size() > 0:
		emit_signal("UnselectedEntitiesChanged", unselectedEnties)
		

		
func getCountries():
	return $Countries.get_children()

func getNavPolygon() -> Navigation2D:
	return $Navigation as Navigation2D

"""
HELPER FUNCTIONS
"""
func getCountryColour(countryName : String) -> Color:
	for country in $Countries.get_children():
		if country.name == countryName:
			return country.get_colour()
	return Color(255)
