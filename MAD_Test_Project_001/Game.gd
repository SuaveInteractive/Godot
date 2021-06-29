extends Node2D

# https://www.youtube.com/watch?v=Ad6Us73smNs

onready var nav_2d : Navigation2D = $"World Map/Navigation2D"
onready var line_2d : Line2D = $Line2D

var nuclearExplosionScene = load("res://GameEntities/NuclearExplosion/NuclearExplosion.tscn")

var moveSpeed : float = 20.0

var selectedUnits = []
var target : Vector2 = Vector2(-1, -1)

enum UnitActions {NONE, MoveAction, PatrolAction, TargetAction}
var unitAction = UnitActions.NONE

enum GameActions {NONE, BuildAction}
var gameAction = GameActions.NONE

var actionInfo = null

func _ready():
	$CreateGame.createGame(self)
	
	# Connect to signals
	var err = Signals.connect("NodeCreate", self, "OnNodeCreated")
	err = Signals.connect("BuildStructure", self, "OnBuildStructureEvent")
	err = Signals.connect("UnitSetlected", self, "OnUnitSetlectedEvent")
	err = Signals.connect("EntitySelected", self, "OnUnitSetlectedEvent")
		
func _process(_delta):
	if Input.is_action_pressed("ui_MoveAction"):
		if not selectedUnits.empty():
			GameCommands.MoveCommand.Navigation_Mesh = $"World Map/Navigation2D"
			GameCommands.MoveCommand.Position_To = get_viewport().get_mouse_position()
			GameCommands.MoveCommand.Selected_Units = selectedUnits
			GameCommands.MoveCommand.execute()

func _unhandled_input(event : InputEvent) -> void:	
	if not event is InputEventMouseButton:
		return
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if unitAction == UnitActions.TargetAction:
			for unit in selectedUnits:
				var mouseEvent = event as InputEventMouse
				GameCommands.TargetCommand.Unit_Targeting = selectedUnits
				GameCommands.TargetCommand.Target_Position = mouseEvent.position
				GameCommands.TargetCommand.execute()
			$Targets.showTargets(selectedUnits)
			unitAction = UnitActions.NONE
		elif gameAction == GameActions.BuildAction:
			GameCommands.BuildCommand.Position_Build = get_viewport().get_mouse_position()
			GameCommands.BuildCommand.Build_Country = $Countries.get_child(0)
			GameCommands.BuildCommand.Build_Info = actionInfo
			GameCommands.BuildCommand.execute()
			gameAction = GameActions.NONE
			get_tree().set_input_as_handled()
		elif unitAction == UnitActions.MoveAction:
			if not selectedUnits.empty():
				GameCommands.MoveCommand.Navigation_Mesh = $"World Map/Navigation2D"
				GameCommands.MoveCommand.Position_To = get_viewport().get_mouse_position()
				GameCommands.MoveCommand.Selected_Units = selectedUnits
				GameCommands.MoveCommand.execute()
			unitAction = GameActions.NONE
		elif unitAction == UnitActions.NONE:
			# Clear all the units that were selected
			for unit in selectedUnits:
				unit.setSelected(false)		
			$Targets.hideTargets()
			selectedUnits = []
			
			Signals.emit_signal("UnitsSetlected", selectedUnits)

func _on_Button_button_down():
	$LaunchStrike.launchStrikeOnTargets($Targets.getTargets())

func OnUnitSetlectedEvent(unit):
	if $Countries.isPlayerUnit(unit):
		unit.setSelected(true)
		selectedUnits.append(unit);
		$Targets.showTargets(selectedUnits)
	
		Signals.emit_signal("UnitsSetlected", selectedUnits)
	
func TargetPressed():
	unitAction = UnitActions.TargetAction
	
func OnMovePressed():
	unitAction = UnitActions.MoveAction

func OnNodeCreated(_type, _obj) -> void:
	_obj.connect("targetReached", self, "OnTargetReached")
	
func OnBuildStructureEvent(buildInfo):
	gameAction = GameActions.BuildAction
	actionInfo = buildInfo

func OnTargetReached(_target, _hits):
	var nuclearExplosionInstance = nuclearExplosionScene.instance()
	nuclearExplosionInstance.position = _target
	add_child(nuclearExplosionInstance)
	nuclearExplosionInstance.play()
	
	#Check any hits
	for hit in _hits:
		if hit == $City:
			$City.setPopulation(49)
			
func OnPostLoad():
	selectedUnits = []
	unitAction = UnitActions.NONE
	$UnitMenu.visible = false
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


