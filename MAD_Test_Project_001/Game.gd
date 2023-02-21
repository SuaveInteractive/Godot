extends Node2D

# https://www.youtube.com/watch?v=Ad6Us73smNs

var nuclearExplosionScene = load("res://GameEntities/NuclearExplosion/NuclearExplosion.tscn")
var worldDefinition = "res://Data/World/WorldInformation_003.tres"

var moveSpeed : float = 20.0

var WorldController = null
var ControllingCountry = null

func _ready():	
	WorldController = $"ViewportContainer/Viewport/World/World Controller"
	
	$CreateGame.createGame(self, worldDefinition)
		
	var countrollingCountry = WorldController.getCountries()[0]
	SetControllingCountry(countrollingCountry)
	
	# Connect to signals
	Signals.connect("NodeCreate", self, "OnNodeCreated")
		
func _process(_delta):
	var selectedUnits = WorldController.getSelectedUnits()
	
	#TODO: Figure out a cleaner way to do this
	$"UI Layer/UI/UnitMenu".ProcessUnitsSelection(selectedUnits)
	
	$GameRules.checkRules(WorldController.getCountries())	
	if Input.is_action_just_pressed ("ui_MoveAction"):
		if not selectedUnits.empty():
			GameCommands.MoveCommand.Navigation_Mesh = WorldController.getNavPolygon()
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

func OnNodeCreated(_type, _obj) -> void:
	_obj.connect("targetReached", self, "OnTargetReached")
	
func OnTargetReached(target, hits):
	var nuclearExplosionInstance = nuclearExplosionScene.instance()
	nuclearExplosionInstance.position = target
	add_child(nuclearExplosionInstance)
	nuclearExplosionInstance.play()
	
	#Check any hits
	for hit in hits:
		if hit.is_class("City"):
			hit.setPopulation(49)
			
func SetControllingCountry(country):
	ControllingCountry = country
	
	$"UI Layer/UI/PlayerInformation/TopBarInfoContainer/FinanceInfoContainer/FinanceValue".text = str(country.get_finance())
	$"UI Layer/UI/PlayerInformation/TopBarInfoContainer/ControlInfoContainer/ControlValue".text = str(country.get_control())
	
	ControllingCountry.connect("CountryFinanceChange", $"UI Layer/UI/PlayerInformation/TopBarInfoContainer/FinanceInfoContainer/FinanceValue", "OnCountryFinanceChange")
	ControllingCountry.connect("CountryControlChange", $"UI Layer/UI/PlayerInformation/TopBarInfoContainer/ControlInfoContainer/ControlValue", "OnCountryControlChange")
	
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

func _on_Build_UIBuildStructure(buildInfo):
	var actionInfo = buildInfo	
	
	actionInfo.BuildCountry = WorldController.getCountries()[0]
	actionInfo.BuildArea = WorldController.getCountryBuildArea()
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
