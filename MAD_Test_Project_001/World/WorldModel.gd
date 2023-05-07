extends Node

"""
Documentation:
https://miro.com/app/board/uXjVPBx20R0=/ 
"""

var countryScene = load("res://GameLogic/Country.tscn")
var targetScene = load("res://GameEntities/Target/Target.tscn")
var nuclearExplosionScene = load("res://GameEntities/NuclearExplosion/NuclearExplosion.tscn")

signal WorldEntitySelected(country, entity)

signal WorldMapTextureUpdates(texture)

signal SelectedEntitiesChanged(selectedEntities)
signal UnselectedEntitiesChanged(unselectedEntities)

var WorldModelResource : Resource = null
var WorldView : Node = null

var SelectedEntities : Array = []

var LandMapRID : RID 
var WaterMapRID : RID 
	
func _ready():
	WorldView = get_node("World View")
	
func _init():
	pass

func setWorldModel(worldModelRes : Resource) -> void:
	if WorldModelResource != worldModelRes:
		WorldModelResource = worldModelRes
			
		# create a new navigation map
		LandMapRID = Navigation2DServer.map_create()
		RIDMapper.addMapping("LandMapRID", LandMapRID)
		var landRegion = Navigation2DServer.region_create()
		Navigation2DServer.region_set_transform(landRegion, Transform())
		Navigation2DServer.region_set_map(landRegion, LandMapRID)
		Navigation2DServer.region_set_navpoly(landRegion, WorldModelResource.LandNavigation)
		
		WaterMapRID = Navigation2DServer.map_create()
		RIDMapper.addMapping("WaterMapRID", WaterMapRID)
		var waterRegion = Navigation2DServer.region_create()		
		Navigation2DServer.region_set_transform(waterRegion, Transform())
		Navigation2DServer.region_set_map(waterRegion, WaterMapRID)
		Navigation2DServer.region_set_navpoly(waterRegion, WorldModelResource.WaterNavigation)
				
		Navigation2DServer.map_set_active(WaterMapRID, true)
		
		_updateCountry(WorldModelResource.Countries)
		_updateUnits(WorldModelResource.Units)
		_updateBuildings(WorldModelResource.Buildings)
		emit_signal("WorldMapTextureUpdates", WorldModelResource.Map)
		
func _updateCountry(countries):
	for country in countries:
		var newCountry  = countryScene.instance()
		newCountry.initialize(country.CountryName,  country.CountryColor, country.CountryBoarder)	
		$Countries.add_child(newCountry)
		
		newCountry.connect("UnitSelected", self, "OnCountryUnitSelected")
		newCountry.connect("CountryTargetHit", self, "OnCountryTargetHit")
		newCountry.connect("CountryBuildingAdded", self, "OnCountryBuildingAdded")
	
func _updateUnits(units):
	for unit in units:	
		var country = getCountry(unit.UnitCountry)
		country.addUnit(unit)
"""
	Accessors
"""
func getWorldSize() -> Vector2:
	return WorldModelResource.Size

"""
	Building Functions
"""
func _updateBuildings(buildings):
	for building in buildings:
		addBuilding(building.BuildingType, building.BuildingPosition, building.BuildingCountry)
	
func addBuilding(buildingType, buildingPosition, buildingCountry):
	var country = getCountry(buildingCountry)
	country.addBuilding(buildingType, buildingPosition)

"""
	Weapons Functions
"""	
func addTarget(selectedUnit, targetPos):
	var targetInstance = targetScene.instance()
	targetInstance.position = targetPos
	targetInstance.set_name("target")
	targetInstance.visible = isEntitySelected(selectedUnit)
	
	var targetNode = selectedUnit.get_node("TargetNode")
	if targetNode != null:
		targetNode.add_child(targetInstance)
	else:
		selectedUnit.add_child(targetInstance)
		
func getTargetsForCountry(countryObj) -> Array:
	var targets : Array = []
	
	targets.append_array(_getTargetsFromNodeArray(countryObj.get_node("Units").get_children()))
	targets.append_array(_getTargetsFromNodeArray(countryObj.get_node("Buildings").get_children()))
		
	return targets
	
func _getTargetsFromNodeArray(nodeArray) -> Array:
	var ret : Array = []
	for node in nodeArray:
		var foundTargets = _getNodeTargets(node)
		if !foundTargets.empty():
			ret.append(foundTargets)
	return ret
	
func _getNodeTargets(node) -> Dictionary:	
	var targetorTargets : Dictionary = {}
	targetorTargets["targetor"] = node
	targetorTargets["targets"] = []
		
	if node.has_node("TargetNode"):
		for target in node.get_node("TargetNode").get_children():
			targetorTargets["targets"].append(target.position)
			
	if targetorTargets["targets"].size() < 1:
		return {}
	
	return targetorTargets
			
func launchMissile(country, source, target):
	country.addMissile(source, target)

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
		
func isEntitySelected(var entity) -> bool:
	for selectedEntity in SelectedEntities:
		if entity.has_node("Selection"):
			var selectionNode = entity.get_node("Selection")
			if selectedEntity == selectionNode:
				return true
	return false
		
"""
	Country Functions
"""	
func getCountries():
	return $Countries.get_children()
	
func getCountry(countryName : String):
	for country in $Countries.get_children():
		if country.name == countryName:
			return country
	return null

func getCountryColour(countryName : String) -> Color:
	var country = getCountry(countryName)
	if country != null:
		return country.get_colour()
	return Color(255)

"""
HELPER FUNCTIONS
"""
func getMapRID() -> RID:
	return WaterMapRID

"""
	Callbacks
"""	
func OnCountryUnitSelected(country, entity):
	emit_signal("WorldEntitySelected", country, entity)
	
func OnCountryTargetHit(_country, target, hits):
	var nuclearExplosionInstance = nuclearExplosionScene.instance()
	nuclearExplosionInstance.position = target
	add_child(nuclearExplosionInstance)
	nuclearExplosionInstance.play()
	
	#Check any hits
	for hit in hits:
		if hit.is_class("City"):
			hit.setPopulation(49)

func OnCountryBuildingAdded(_building):
	pass
