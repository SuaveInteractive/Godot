extends Node

#var countryScript = load("res://GameLogic/Country.gd")
var AIOpponentScript = load("res://AI/AIOpponent.gd")

""" DEBUG SETUP """
var DebugShowCountryBoardersScript = load("res://Debug/DebugShowCountryBoarders.gd")
var DebugDetectorInformation = load("res://DetectorRendering/Debug/DebugDetectorInformation.gd")
var DebugScriptController = load("res://Script/Debug/DebugMenuScriptController.gd")
var DebugCountryController = load("res://Debug/Countries/DebugMenuCountriesController.gd")
var DebugShowAIStateScript = load("res://Debug/AIState/DebugShowAIState.gd")

func createGame(gameObject, worldInformation):
	# world
	gameObject.get_node("ViewportContainer/Viewport/World/World Controller").loadWorld(worldInformation)

	""" Debug """
	var boarders : Array = []
	for country in gameObject.WorldController.getCountries():
		boarders.append(country.Boarder)
	var debugControl = DebugShowCountryBoardersScript.new(boarders)
	DebugOverlay.addDebugControl(debugControl)
	
	debugControl = DebugDetectorInformation.new(get_parent().find_node("DetectionMap"))
	DebugOverlay.addDebugControl(debugControl)
	
	debugControl = DebugScriptController.new(get_parent().getScriptRunner(), ScriptRecorder)
	DebugOverlay.addDebugControl(debugControl)
	
	debugControl = DebugCountryController.new(gameObject.WorldController.getCountries(), funcref(gameObject, "SetControllingCountry"))
	gameObject.connect("ControllingCountryChanged", debugControl, "OnControllingCountryChanged")
	DebugOverlay.addDebugControl(debugControl)
	
	#debugControl = DebugShowAIStateScript.new(AIList)
#
#func _CreateCountry(countryInfo):
#	var country = countryScript.new(countryInfo.CountryName, countryInfo.CountryColor)
#
#	""" Create Country Boarders """
#	var countryBoarder = _CreateCountryBoarders(countryInfo.CountryBoarder)
#	country.add_child(countryBoarder)
#
#	return country
#
#func _CreateCountryBoarders(countryBoarderInfo):
#	var collisionPoly = CollisionPolygon2D.new()
#	collisionPoly.name = "Boarder"
#	collisionPoly.polygon = countryBoarderInfo
#	return collisionPoly

