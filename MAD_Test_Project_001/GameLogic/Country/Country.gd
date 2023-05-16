extends Node
class_name Country

# Buildings
var BuildingFactory = null

# Units
var submarineScene = load("res://GameEntities/Submarine/Submarine.tscn")

# Missiles
var targetScene = load("res://GameEntities/Target/Target.tscn")
var missileScene = load("res://GameEntities/Missile/Missile.tscn")

signal UnitSelected(country, unit)

signal CountryControlChange(oldControl, newControl)
signal CountryFinanceChange(oldFinance, newFinance)

signal CountryTargetHit(country, target, hits)

signal CountryBuildingAdded(building)
signal CountryDetectionUpdated(country)

var CountryColour : Color = Color(255) setget , get_colour
var Boarder : PoolVector2Array 

var Control : int = 0 setget set_control, get_control
var Finance : int = 0 setget set_finance, get_finance

func _init():
	BuildingFactory = load("res://GameEntities/Structure/StructureFactory.gd").new()
	add_child(BuildingFactory)

func initialize(name, color, boarder):
	self.set_name(name) 
	CountryColour = color
	Boarder = boarder
	
	set_control(85)
	set_finance(1000000)
	
	self.add_to_group('Persistent')
	
func _process(_delta):
	set_control(calculateControl())
	
func calculateControl() -> int:
	var control: int = 85
	
	for child in $Buildings.get_children():
		if child.is_class("City"):
			var cityPop = child.getPopulation()
			var per: float  = (float(cityPop)/100)
			control = int(control * per)
		
	return control
	
func set_control(control: int) -> void:
	if Control != control:
		emit_signal("CountryControlChange", Control, control)
		Control = control
		
func get_control() -> int:
	return Control
	
func set_finance(finance: int) -> void:
	if Finance != finance:
		emit_signal("CountryFinanceChange", Finance, finance)
		Finance = finance
	
func get_finance() -> int:
	return Finance
	
func reduceFinance(var reduction: int) -> void:
	var newFinance = Finance - reduction
	set_finance(newFinance)
	
func get_colour() -> Color:
	return CountryColour
	
func getDetectionArea() -> Array:
	var ret : Array = []
	
	# Buildings
	for building in $Buildings.get_children():
		if building.isStructureConstructing() == false:
			var detectorNode = building.get_node("DetectorNode")
			if detectorNode != null:
				ret.append(detectorNode)
	
	# Units
	for unit in $Units.get_children():
		var detectorNode = unit.get_node("DetectorNode")
		if detectorNode != null:
			ret.append(detectorNode)
	return ret
	
func getIntelligenceInterface():
	return $Intelligence

"""
	Buildings
"""
func addBuilding(type, pos):
	var buildingInstance = BuildingFactory.getBuildingInstance(type)
	
	buildingInstance.position = pos
	buildingInstance.z_index = 1
	$Buildings.add_child(buildingInstance)
	
	buildingInstance.connect("ConstructionFinished", self, "OnConstructionFinished")
	
	if buildingInstance.has_node("Selection"):
		buildingInstance.get_node("Selection").connect("EntitySelected", self, "OnUnitSelected")
	
	if buildingInstance.has_node("CitySprite"):
		buildingInstance.get_node("CitySprite").get_material().set_shader_param("colour", CountryColour)
	
	if buildingInstance.has_node("DetectorNode"):
		var buildingInstanceDetectorNode = buildingInstance.get_node("DetectorNode")
		buildingInstanceDetectorNode.connect("EnitityDetected", self, "OnEnitityDetected")
		buildingInstanceDetectorNode.connect("EnitityUndetected", self, "OnEnitityUndetected")
		$Intelligence.addDetection(null, buildingInstanceDetectorNode)	
	
	emit_signal("CountryBuildingAdded", buildingInstance)
"""
	Units
"""
func addUnit(unit):
	var unitInstance = submarineScene.instance()
	unitInstance.position = unit.UnitPosition
	unitInstance.z_index = 1
	unitInstance.get_node("EntityObfuscation").country_colour = CountryColour
	
	unitInstance.get_node("Selection").connect("EntitySelected", self, "OnUnitSelected")
	
	var unitInstanceDetectorNode = unitInstance.get_node("DetectorNode")
	unitInstanceDetectorNode.connect("EnitityDetected", self, "OnEnitityDetected")
	unitInstanceDetectorNode.connect("EnitityUndetected", self, "OnEnitityUndetected")
		
	unitInstance.set_name("unit")
	$Units.add_child(unitInstance)
	
	$Intelligence.addDetection(null, unitInstanceDetectorNode)

"""
	Weapons
"""
func addMissile(source, target) -> void:
	var missileInstance = missileScene.instance()
	missileInstance.set_name("missile")
	missileInstance.setTarget(target)
	missileInstance.position = source
	
	missileInstance.connect("targetReached", self, "OnTargetReached")
	
	$Missiles.add_child(missileInstance)
	
"""
	Callbacks
"""
func OnUnitSelected(entity) -> void:
	emit_signal("UnitSelected", self, entity)
	
func OnTargetReached(target, hits):
	emit_signal("CountryTargetHit", self, target, hits)
	
func OnEnitityDetected(detectorEntity, entityDetectorNode) -> void:
	$Intelligence.addDetection(detectorEntity, entityDetectorNode)
	
func OnEnitityUndetected(detectorEntity, entityDetectorNode) -> void:
	$Intelligence.removeDetection(detectorEntity, entityDetectorNode)
	
func OnConstructionFinished(structure) -> void:
	if structure.has_node("DetectorNode"):
		emit_signal("CountryDetectionUpdated", self)
