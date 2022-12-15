extends Node

var cityScene = load("res://GameEntities/City/City.tscn")
var submarineScene = load("res://GameEntities/Submarine/Submarine.tscn")

var countryScript = load("res://GameLogic/Country.gd")
var AIOpponentScript = load("res://AI/AIOpponent.gd")

""" DEBUG SETUP """
var DebugShowCountryBoardersScript = load("res://Debug/DebugShowCountryBoarders.gd")
var DebugShowAIStateScript = load("res://Debug/AIState/DebugShowAIState.gd")

func createGame(gameObject, worldInformation):
	# Map
	gameObject.get_node("World/World Controller").loadWorld(worldInformation)

	""" Debug """
	#var boarders : Array = []
	#for countryInfo in worldInformation.Countries:
	#	boarders.append(countryInfo.CountryBoarder)
	#var debugControl = DebugShowCountryBoardersScript.new(boarders)
	#DebugOverlay.addDebugControl(debugControl)
	
	#debugControl = DebugShowAIStateScript.new(AIList)

func _CreateCountry(countryInfo):
	var country = countryScript.new(countryInfo.CountryName, countryInfo.CountryColor)
	
	""" Create Country Boarders """
	var countryBoarder = _CreateCountryBoarders(countryInfo.CountryBoarder)
	country.add_child(countryBoarder)
	
	""" Create Country Structures """
	#for cityInfo in countryInfo.Cities:
	#	if cityInfo != null:
	#		var newCity = _CreateCity(cityInfo)
	#		country.addCity(newCity)
			
	""" Create Country Units """
	#for subInfo in countryInfo.Submarines:
	#	if subInfo != null:
	#		var newSub = _CreateSub(subInfo)
	#		country.addUnit(newSub)
	
	return country
	
func _CreateCountryBoarders(countryBoarderInfo):
	var collisionPoly = CollisionPolygon2D.new()
	collisionPoly.name = "Boarder"
	collisionPoly.polygon = countryBoarderInfo
	return collisionPoly

func _CreateCity(cityInfo):
	var cityInstance = cityScene.instance()
	cityInstance.position = cityInfo
	cityInstance.set_name("city_1")
	cityInstance.z_index = 1
	return cityInstance

func _CreateSub(subInfo):
	var submarineInstance = submarineScene.instance()
	submarineInstance.position = subInfo
	submarineInstance.set_name("submarine_1")
	submarineInstance.z_index = 1
	return submarineInstance

