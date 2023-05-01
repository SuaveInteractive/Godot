extends Node
class_name Country

# Buildings
var cityScene = load("res://GameEntities/City/City.tscn")
var siloScene = load("res://GameEntities/Silo/Silo.tscn")

# Units
var submarineScene = load("res://GameEntities/Submarine/Submarine.tscn")

# Missiles
var targetScene = load("res://GameEntities/Target/Target.tscn")
var missileScene = load("res://GameEntities/Missile/Missile.tscn")

signal UnitSelected(country, unit)

signal CountryControlChange(oldControl, newControl)
signal CountryFinanceChange(oldFinance, newFinance)

signal CountryTargetHit(country, target, hits)

var CountryColour : Color = Color(255) setget , get_colour
var Boarder : PoolVector2Array 

var Control : int = 0 setget set_control, get_control
var Finance : int = 0 setget set_finance, get_finance

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
	for buildings in $Buildings.get_children():
		var detectorNode = buildings.get_node("DetectorNode")
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
	var buildingInstance = null 
	if type == "Silo":
		buildingInstance = siloScene.instance()
	else:
		buildingInstance = cityScene.instance()
	
	buildingInstance.position = pos
	buildingInstance.z_index = 1
	buildingInstance.set_name("building")
	$Buildings.add_child(buildingInstance)
	
	if buildingInstance.has_node("Selection"):
		buildingInstance.get_node("Selection").connect("EntitySelected", self, "OnUnitSelected")
	
	if buildingInstance.has_node("CitySprite"):
		buildingInstance.get_node("CitySprite").get_material().set_shader_param("colour", CountryColour)
		
	buildingInstance.get_node("DetectorNode").connect("EnitityDetected", self, "OnEnitityDetected")
	buildingInstance.get_node("DetectorNode").connect("EnitityUndetected", self, "OnEnitityUndetected")
"""
	Units
"""
func addUnit(unit):
	var unitInstance = submarineScene.instance()
	unitInstance.position = unit.UnitPosition
	unitInstance.z_index = 1
	#unitInstance.get_node("SubmarineSprite").get_material().set_shader_param("colour", CountryColour)
	unitInstance.get_node("EntityObfuscation").country_colour = CountryColour
	
	unitInstance.get_node("Selection").connect("EntitySelected", self, "OnUnitSelected")
	
	unitInstance.get_node("DetectorNode").connect("EnitityDetected", self, "OnEnitityDetected")
	unitInstance.get_node("DetectorNode").connect("EnitityUndetected", self, "OnEnitityUndetected")
		
	unitInstance.set_name("unit")
	$Units.add_child(unitInstance)
	
	$Intelligence.addDetection(unitInstance.get_node("DetectorNode"))

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
	
func OnEnitityDetected(entity) -> void:
	$Intelligence.addDetection(entity)
	
func OnEnitityUndetected(entity) -> void:
	$Intelligence.removeDetection(entity)
