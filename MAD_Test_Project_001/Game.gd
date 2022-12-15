extends Node2D

# https://www.youtube.com/watch?v=Ad6Us73smNs

var nuclearExplosionScene = load("res://GameEntities/NuclearExplosion/NuclearExplosion.tscn")
var worldDefinition = "res://Data/World/WorldInformation_003.tres"

var moveSpeed : float = 20.0

#enum UnitActions {NONE, MoveAction, PatrolAction, TargetAction}
var unitAction = Enums.UnitActions.NONE

#enum GameActions {NONE, BuildAction}
var gameAction = Enums.GameActions.NONE

var actionInfo = null

func _ready():	
	$CreateGame.createGame(self, worldDefinition)
	
	# Connect to signals
	Signals.connect("NodeCreate", self, "OnNodeCreated")
	Signals.connect("PlayerBuildStructure", self, "OnPlayerBuildStructureEvent")
	Signals.connect("CountryWins", self, "OnCountryWins")
		
func _process(_delta):
	var worldController = $"World/World Controller"
	var selectedUnits = worldController.getSelectedUnits()
	
	#TODO: Figure out a cleaner way to do this
	$"UI Layer/UI/UnitMenu".OnUnitsSelected(selectedUnits)
	
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
			for unit in selectedEntities:
				var mouseEvent = event as InputEventMouse
				GameCommands.TargetCommand.Unit_Targeting = selectedEntities
				GameCommands.TargetCommand.Target_Position = get_local_mouse_position()
				GameCommands.TargetCommand.execute()
			$Targets.showTargets(selectedEntities)
			unitAction = Enums.UnitActions.NONE
		elif unitAction == Enums.UnitActions.MoveAction:
			if not selectedEntities.empty():
				GameCommands.MoveCommand.Navigation_Mesh = $"World/WorldMap/Navigation2D"
				GameCommands.MoveCommand.Position_To = get_local_mouse_position()
				GameCommands.MoveCommand.Selected_Units = selectedEntities
				GameCommands.MoveCommand.execute()
			unitAction = Enums.UnitActions.NONE
		elif unitAction == Enums.UnitActions.NONE:
			# Clear all the units that were selected
			$Targets.hideTargets()
			worldController.setSelectedEntities([])
			
			Signals.emit_signal("UnitsSelected", selectedEntities)

func _on_Button_button_down():
	$LaunchStrike.launchStrikeOnTargets($Targets.getTargets())

func OnCountryWins(country) -> void:
	get_node("UI Layer/UI/ResultLable").visible = true
	if country.get_player():
		get_node("UI Layer/UI/ResultLable").text = "YOU WIN"
	else:
		get_node("UI Layer/UI/ResultLable").text = "YOU LOSE"
		
func TargetPressed():
	unitAction = Enums.UnitActions.TargetAction
	
func OnMovePressed():
	unitAction = Enums.UnitActions.MoveAction

func OnNodeCreated(_type, _obj) -> void:
	_obj.connect("targetReached", self, "OnTargetReached")
	
func OnPlayerBuildStructureEvent(buildInfo):
	SetGameAction(Enums.GameActions.BuildAction)
	actionInfo = buildInfo	
	var playerCountry = $"World/Countries".get_child(0)
	actionInfo.BuildCountry = playerCountry
	$GameActions.startAction(actionInfo)

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
	$Targets.hideTargets()

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


