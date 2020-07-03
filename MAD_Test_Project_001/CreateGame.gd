extends Node

var cityScene = load("res://City.tscn")
var submarineScene = load("res://GameEntities/Submarine/Submarine.tscn")

var countryScript = load("res://GameLogic/Country.gd")
var AIPlayerScript = load("res://GameLogic/AIPlayer.gd")

func createGame(_parent):
	# Countries
	var Country_1 = countryScript.new("Country_1", true, Color(1, 0, 0, 1))
	_parent.add_child(Country_1)
	
	var cityInstance = cityScene.instance()
	cityInstance.position = Vector2(190, 190)
	cityInstance.set_name("city_1")
	Country_1.addCity(cityInstance)
	
	# Units
	var submarineInstance = submarineScene.instance()
	submarineInstance.position = Vector2(630, 130)
	submarineInstance.set_name("submarine_1")
	Country_1.addUnit(submarineInstance)
		
	# AI Player
	var Country_2 = countryScript.new("Country_2", false, Color(0, 1, 0, 1))
	_parent.add_child(Country_2)
	
	cityInstance = cityScene.instance()
	cityInstance.position = Vector2(639, 427)
	cityInstance.set_name("city_2")
	Country_2.addCity(cityInstance)
	
	# Units
	submarineInstance = submarineScene.instance()
	submarineInstance.position = Vector2(400, 550)
	submarineInstance.set_name("submarine_1")
	Country_2.addUnit(submarineInstance)
	
	# AIPlayers
	var AIPlayer_1 = AIPlayerScript.new("AIPlayer_1", Country_2)
	_parent.add_child(AIPlayer_1)
	
