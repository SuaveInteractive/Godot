extends Node2D

var WorldScene = preload("res://World/World.tscn")

func _ready():
	var world = WorldScene.instance()
	
	var worldController = world.get_node("World Controller")
	add_child(world)
	worldController.loadWorld("res://Data/World/WorldInformation_003.tres")
	
	# Setup a target and lauch a missile
	var selectedUnit = $"/root/TestWorld/World/World Controller/World Model/Countries/Country_1/Units/unit"
	worldController.addTarget(selectedUnit, Vector2(450, 300))
	worldController.launchMissile($"/root/TestWorld/World/World Controller/World Model/Countries/Country_1", Vector2(100, 100), Vector2(200, 500))
	
	worldController.getTargetsForCountry(worldController.getCountries()[0])
	
	# Set up some obfuscated intelligence for a country
	var countryIntel = worldController.getCountries()[0].getIntelligenceInterface()
	countryIntel.addDetection(null, $"/root/TestWorld/World/World Controller/World Model/Countries/Country_1/Units/unit")
	world.setIntelligenceInterface(countryIntel)
