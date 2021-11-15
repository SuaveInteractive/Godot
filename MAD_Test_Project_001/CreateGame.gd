extends Node

var cityScene = load("res://GameEntities/City/City.tscn")
var submarineScene = load("res://GameEntities/Submarine/Submarine.tscn")

var countryScript = load("res://GameLogic/Country.gd")
var AIOpponentScript = load("res://AI/AIOpponent.gd")

func createGame(gameObject, worldInformation):
	# Countries
	
	for countryInfo in worldInformation.Countries:
		if countryInfo != null:
			var newCountry = _CreateCountry(countryInfo)
			gameObject.get_node("World/Countries").add_child(newCountry)

	""" Hardcoded parameters """
	# AI Player
	var Country_2 = countryScript.new("Country_2", false, Color(0, 1, 0, 1))
	gameObject.get_node("World/Countries").add_child(Country_2)
	
	var cityInstance = cityScene.instance()
	cityInstance.position = Vector2(639, 427)
	cityInstance.set_name("city_2")
	cityInstance.z_index = 1
	Country_2.addCity(cityInstance)
	
	# Units
	var submarineInstance = submarineScene.instance()
	submarineInstance.position = Vector2(400, 550)
	submarineInstance.set_name("submarine_1")
	submarineInstance.z_index = 1
	Country_2.addUnit(submarineInstance)
	
	# AIPlayers
	var AIPlayer_1 = AIOpponentScript.new("AIPlayer_1", Country_2)
	gameObject.add_child(AIPlayer_1)

func _CreateCountry(countryInfo):
	var country = countryScript.new(countryInfo.CountryName, true, countryInfo.CountryColor)
	
	""" Create Country Boarders """
	var countryBoarder = _CreateCountryBoarders(countryInfo.CountryBoarder)
	country.add_child(countryBoarder)
	
	""" Create Country Structures """
	for cityInfo in countryInfo.Cities:
		if cityInfo != null:
			var newCity = _CreateCity(cityInfo)
			country.addCity(newCity)
			
	""" Create Country Units """
	for subInfo in countryInfo.Submarines:
		if subInfo != null:
			var newSub = _CreateSub(subInfo)
			country.addUnit(newSub)
	
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

