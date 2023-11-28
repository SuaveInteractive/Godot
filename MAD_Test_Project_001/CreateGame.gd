extends Node

#var countryScript = load("res://GameLogic/Country.gd")
var AIOpponentScript = load("res://AI/AIOpponent.gd")

""" DEBUG SETUP """
var DebugShowCountryBoardersScript = load("res://Debug/DebugShowCountryBoarders.gd")
var DebugDetectorInformation = load("res://DetectorRendering/Debug/DebugDetectorInformation.gd")
var DebugScriptController = load("res://Script/Debug/DebugMenuScriptController.gd")
var DebugCountryController = load("res://Debug/Countries/DebugMenuCountriesController.gd")
var DebugMenuDetectionState = load("res://Debug/Detection/DebugMenuDetectionState.gd")
var DebugShowAIStateScript = load("res://Debug/AIState/DebugShowAIState.gd")
var DebugWorldScreenPositionScript = load("res://Debug/WorldScreenPosition/WorldScreenPosition.gd")

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
	
	debugControl = DebugMenuDetectionState.new()
	gameObject.connect("ControllingCountryChanged", debugControl, "OnControllingCountryChanged")
	DebugOverlay.addDebugControl(debugControl)
	
	debugControl = DebugWorldScreenPositionScript.new(gameObject)
	DebugOverlay.addDebugControl(debugControl)
