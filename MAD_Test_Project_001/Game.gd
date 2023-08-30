extends Node2D

signal ControllingCountryChanged(country)

# https://www.youtube.com/watch?v=Ad6Us73smNs
var worldDefinition = "res://Data/World/WorldInformation_003.tres"

var ScriptRunnerClass = preload("res://Script/ScriptRunner.gd")
var ScriptRunner = null setget , getScriptRunner

var moveSpeed : float = 20.0

var WorldController = null
var ControllingCountry = null setget ,getControllingCountry

func _ready():	
	WorldController = $"ViewportContainer/Viewport/World/World Controller"
	
	ScriptRunner = ScriptRunnerClass.new()
	ScriptRunner.addCommand(GameCommands.MoveCommand)
	ScriptRunner.addCommand(GameCommands.TargetCommand)
	ScriptRunner.addCommand(GameCommands.BuildCommand)
	ScriptRunner.addCommand(GameCommands.LaunchStrikeCommand)
	
	add_child(ScriptRunner)
	
	$CreateGame.createGame(self, worldDefinition)
		
	var countrollingCountry = WorldController.getCountries()[0]
	SetControllingCountry(countrollingCountry)
	
	$ViewportContainer.material.set_shader_param("maskTexture", $DetectionMap.get_texture())
		
func _process(_delta):
	var selectedUnits = WorldController.getSelectedUnits()
	
	#TODO: Figure out a cleaner way to do this
	$"UI Layer/UI/UnitMenu".ProcessUnitsSelection(selectedUnits)
	
	$GameRules.checkRules(WorldController.getCountries())	
	if Input.is_action_just_pressed ("ui_MoveAction"):
		if not selectedUnits.empty():
			GameCommands.MoveCommand.MapName = "WaterMapRID"
			GameCommands.MoveCommand.Position_To = get_local_mouse_position()
			GameCommands.MoveCommand.Selected_Units = selectedUnits			
			GameCommands.MoveCommand.execute()
		
func _on_Button_button_down():
	var actionInfo = {"ActionName": "LaunchStrikeAction"}	
	actionInfo.WorldController = WorldController
	actionInfo.ControllingCountry = ControllingCountry
	$GameActions.startAction(actionInfo)
		
func TargetPressed():
	var selectedUnits = WorldController.getSelectedUnits()
	
	var actionInfo = {"ActionName": "TargetAction", "SelectedUnits": selectedUnits}
	
	actionInfo.WorldController = WorldController
	$GameActions.startAction(actionInfo)
	
func OnMovePressed():
	var selectedUnits = WorldController.getSelectedUnits()
	
	var actionInfo = {"ActionName": "MoveUnitAction", "SelectedUnits": selectedUnits}
	actionInfo.WorldController = WorldController
	
	$GameActions.startAction(actionInfo)
			
func SetControllingCountry(country):
	if ControllingCountry:
		$ViewportContainer/Viewport/World.disconnectIntelligenceInterface(ControllingCountry.getIntelligenceInterface())
		ControllingCountry.disconnect("CountryFinanceChange", $"UI Layer/UI/PlayerInformation/TopBarInfoContainer/FinanceInfoContainer/FinanceValue", "OnCountryFinanceChange")
		ControllingCountry.disconnect("CountryControlChange", $"UI Layer/UI/PlayerInformation/TopBarInfoContainer/ControlInfoContainer/ControlValue", "OnCountryControlChange")
		ControllingCountry.disconnect("CountryDetectionUpdated", self, "OnCountryDetectionChanged")
		
		setDetectionVisibility(ControllingCountry, false)
		
	ControllingCountry = country
	
	$"UI Layer/UI/PlayerInformation/TopBarInfoContainer/FinanceInfoContainer/FinanceValue".text = str(country.get_finance())
	$"UI Layer/UI/PlayerInformation/TopBarInfoContainer/ControlInfoContainer/ControlValue".text = str(country.get_control())
	
	ControllingCountry.connect("CountryFinanceChange", $"UI Layer/UI/PlayerInformation/TopBarInfoContainer/FinanceInfoContainer/FinanceValue", "OnCountryFinanceChange")
	ControllingCountry.connect("CountryControlChange", $"UI Layer/UI/PlayerInformation/TopBarInfoContainer/ControlInfoContainer/ControlValue", "OnCountryControlChange")
	ControllingCountry.connect("CountryDetectionUpdated", self, "OnCountryDetectionChanged")
	
	$DetectionMap.setDetectionAreas(ControllingCountry.getDetectionArea())
	$ViewportContainer/Viewport/World.setIntelligenceInterface(ControllingCountry.getIntelligenceInterface())
	setDetectionVisibility(ControllingCountry, $"UI Layer/UI/ShowRadar".pressed)
	
	emit_signal("ControllingCountryChanged", ControllingCountry)
	
func getScriptRunner():
	return ScriptRunner
	
func getControllingCountry():
	return ControllingCountry
	
func setDetectionVisibility(var country, var visibile) -> void:
	for detectionNode in country.getDetectionArea():
		detectionNode.setDetectionAreaVisibility(visibile)
	
# https://docs.godotengine.org/en/3.1/tutorials/io/saving_games.html
# C:\Users\Manix\AppData\Roaming\Godot\app_userdata\MAD_Test_Project_001
func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persistent")
	for i in save_nodes:
		var node_data = i.call("save");
		save_game.store_line(to_json(node_data))
	save_game.close()
	
"""
	Callbacks
"""
func _on_Build_UIBuildStructure(buildInfo):
	var actionInfo = buildInfo	
	
	actionInfo.BuildCountry = getControllingCountry()
	actionInfo.BuildArea = getControllingCountry().Boarder
	actionInfo.WorldController = WorldController
	$GameActions.startAction(actionInfo)
	
func _on_GameRules_CountryWins(country):
	get_node("UI Layer/UI/ResultLable").visible = true
	if country == ControllingCountry:
		get_node("UI Layer/UI/ResultLable").text = "YOU WIN"
	else:
		get_node("UI Layer/UI/ResultLable").text = "YOU LOSE"

func _on_World_WorldEntitySelected(country, entity):
	if ControllingCountry == country:
		WorldController.setSelectedEntities([entity])
		
func OnCountryDetectionChanged(country):
	if ControllingCountry == country:
		$DetectionMap.setDetectionAreas(ControllingCountry.getDetectionArea())
		setDetectionVisibility(ControllingCountry, $"UI Layer/UI/ShowRadar".pressed)

func _on_ShowRadar_toggled(button_pressed):
	setDetectionVisibility(ControllingCountry, button_pressed)

func _on_CreateIntelligencePackageBtn_toggled(button_pressed):
	if button_pressed:
		var actionInfo = {"ActionName": "CreateIntelPackageAction"}	
		actionInfo["ControllingCountry"] = ControllingCountry
		#actionInfo["CountryIntelligence"] = ControllingCountry.getIntelligenceInterface()
		$GameActions.startAction(actionInfo)
	else:
		$GameActions.endAction()
