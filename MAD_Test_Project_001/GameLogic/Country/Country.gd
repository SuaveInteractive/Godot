extends Node
class_name Country

# Buildings
var BuildingFactory = null

# Units
var submarineScene = load("res://GameEntities/Unit/Submarine/Submarine.tscn")

# Missiles
var targetScene = load("res://GameEntities/Target/Target.tscn")
var missileScene = load("res://GameEntities/Missile/Missile.tscn")

"""
	Signals
"""
signal UnitSelected(country, unit)

signal CountryControlChange(oldControl, newControl)
signal CountryFinanceChange(oldFinance, newFinance)

signal CountryTargetHit(country, target, hits)

signal CountryBuildingAdded(building)
signal CountryDetectionUpdated(country)

"""
	Memebers
"""
var CountryColour : Color = Color(255) setget , get_colour
var Boarder : PoolVector2Array 

var Control : int = 0 setget set_control, get_control
var Finance : int = 0 setget set_finance, get_finance

var IntelligencePackages : Array = [] setget , getIntelligencePackages
var ReceivedIntelligencePackages : Array = [] setget , getReceivedIntelligencePackages

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
	
func isOwned(var entity : Node) -> bool:
	for building in $Buildings.get_children():
		var detectorNode = building.get_node("DetectorNode")
		if detectorNode != null && detectorNode == entity:
			return true
	
	for unit in $Units.get_children():
		var detectorNode = unit.get_node("DetectorNode")
		if detectorNode != null && detectorNode == entity:
			return true
			
	return false
	
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
		buildingInstance.get_node("CitySprite").get_material().set_shader_param("replacementColour", CountryColour)
	
	if buildingInstance.has_node("DetectorNode"):
		var buildingInstanceDetectorNode = buildingInstance.get_node("DetectorNode")
		buildingInstanceDetectorNode.connect("EnitityDetected", self, "OnEnitityDetected")
		buildingInstanceDetectorNode.connect("EnitityUndetected", self, "OnEnitityUndetected")
		
		# Want to pass in InformationLevel.TOTAL which equals 4, but GDScript doens't support 
		# predefined enums without making a global :(
		$Intelligence.addIntelFromDetection(null, 4, buildingInstanceDetectorNode)	
	
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
	
	# Want to pass in InformationLevel.TOTAL which equals 4, but GDScript doens't support 
	# predefined enums without making a global :(
	$Intelligence.addIntelFromDetection(null, 4, unitInstanceDetectorNode)

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
	Misc
"""
func addIntelPackage(var intelligencePackage) -> void:
	IntelligencePackages.append(intelligencePackage)

func getIntelligencePackages() -> Array:
	return IntelligencePackages
	
func getIntelligencePackage(var packageName : String) -> Resource:
	for package in IntelligencePackages:
		if package.PackageName == packageName:
			return package
	return null

func addReceivedIntelligencePackage(var receivedInteligencePackage):
	if receivedInteligencePackage != null:
		ReceivedIntelligencePackages.append(receivedInteligencePackage)
	
func getReceivedIntelligencePackages() -> Array:
	return ReceivedIntelligencePackages
	
"""
	Callbacks
"""
func OnUnitSelected(entity) -> void:
	emit_signal("UnitSelected", self, entity)
	
func OnTargetReached(target, hits):
	emit_signal("CountryTargetHit", self, target, hits)
	
func OnEnitityDetected(detectorEntity, detectorShapeIndex, entityDetectorNode) -> void:
	if not isOwned(entityDetectorNode):
		$DetectionProcessing.addDetection(detectorEntity, detectorShapeIndex, entityDetectorNode)
	
func OnEnitityUndetected(detectorEntity, detectorShapeIndex, entityDetectorNode) -> void:
	if not isOwned(entityDetectorNode):
		$DetectionProcessing.removeDetection(detectorEntity, detectorShapeIndex, entityDetectorNode)
	
func OnConstructionFinished(structure) -> void:
	if structure.has_node("DetectorNode"):
		emit_signal("CountryDetectionUpdated", self)
