extends Node2D

# https://www.youtube.com/watch?v=Ad6Us73smNs

var nuclearExplosionScene = load("res://GameEntities/NuclearExplosion/NuclearExplosion.tscn")
var worldDefinition = "res://Data/World/WorldInformation_003.tres"

var moveSpeed : float = 20.0

var unitAction = Enums.UnitActions.NONE

#enum GameActions {NONE, BuildAction}
var gameAction = Enums.GameActions.NONE

var actionInfo = null

var WorldController
var ControllingCountry = null

func _ready():	
	WorldController = $"World/World Controller"
	
	$CreateGame.createGame(self, worldDefinition)
	
	var worldController = $"World/World Controller"
	
	var countrollingCountry = worldController.getCountries()[0]
	SetControllingCountry(countrollingCountry)
	
	# Connect to signals
	Signals.connect("NodeCreate", self, "OnNodeCreated")
		
func _process(_delta):
	var worldController = $"World/World Controller"
	var selectedUnits = worldController.getSelectedUnits()
	
	#TODO: Figure out a cleaner way to do this
	$"UI Layer/UI/UnitMenu".ProcessUnitsSelection(selectedUnits)
	
	$GameRules.checkRules(worldController.getCountries())	
	if Input.is_action_just_pressed ("ui_MoveAction"):
		if not selectedUnits.empty():
			GameCommands.MoveCommand.Navigation_Mesh = worldController.getNavPolygon()
			GameCommands.MoveCommand.Position_To = get_local_mouse_position()
			GameCommands.MoveCommand.Selected_Units = selectedUnits
			GameCommands.MoveCommand.execute()
			
	

func _unhandled_input(event : InputEvent) -> void:	
	if not event is InputEventMouseButton:
		return
		
	var worldController = $"World/World Controller"
	var selectedEntities = worldController.getSelectedUnits()
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if unitAction == Enums.UnitActions.TargetAction:
			pass
		#	for unit in selectedEntities:
		#		var mouseEvent = event as InputEventMouse
		#		GameCommands.TargetCommand.Unit_Targeting = selectedEntities
		#		GameCommands.TargetCommand.Target_Position = get_local_mouse_position()
		#		GameCommands.TargetCommand.execute()
		#	$Targets.showTargets(selectedEntities)
		#	unitAction = Enums.UnitActions.NONE
		elif unitAction == Enums.UnitActions.MoveAction:
			if not selectedEntities.empty():
				GameCommands.MoveCommand.Navigation_Mesh = $"World/WorldMap/Navigation2D"
				GameCommands.MoveCommand.Position_To = get_local_mouse_position()
				GameCommands.MoveCommand.Selected_Units = selectedEntities
				GameCommands.MoveCommand.execute()
			unitAction = Enums.UnitActions.NONE
		elif unitAction == Enums.UnitActions.NONE:
			# Clear all the units that were selected
			worldController.setSelectedEntities([])

func _on_Button_button_down():
	var actionInfo = {"ActionName": "LaunchStrikeAction"}	
	actionInfo.WorldController = WorldController
	actionInfo.ControllingCountry = ControllingCountry
	$GameActions.startAction(actionInfo)
		
func TargetPressed():
	var worldController = $"World/World Controller"
	var selectedUnits = worldController.getSelectedUnits()
	
	var actionInfo = {"ActionName": "TargetAction", "SelectedUnits": selectedUnits}
	
	actionInfo.WorldController = worldController
	$GameActions.startAction(actionInfo)
	
func OnMovePressed():
	unitAction = Enums.UnitActions.MoveAction

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
			
func SetGameAction(gameAction) -> void:
	self.gameAction = gameAction
			
func OnPostLoad():
	#electedEntities = []
	unitAction = Enums.UnitActions.NONE
	#$Targets.hideTargets()
	
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
	SetGameAction(Enums.GameActions.BuildAction)
	actionInfo = buildInfo	
	
	var worldController = $"World/World Controller"
	actionInfo.BuildCountry = worldController.getCountries()[0]
	actionInfo.BuildArea = worldController.getCountryBuildArea()
	actionInfo.WorldController = worldController
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
