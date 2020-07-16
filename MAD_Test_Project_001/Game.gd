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

var Countries = []

func _ready():
	$CreateGame.createGame(self)
	
	# Connect to signals
	var err = Signals.connect("NodeCreate", self, "OnNodeCreated")
		
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
				target = mouseEvent.position
				$Targets.addTarget(unit, target)
			$Targets.showTargets(selectedUnits)
			unitAction = UnitActions.NONE
		elif unitAction == UnitActions.NONE:
			# Clear all the units that were selected
			for unit in selectedUnits:
				unit.setSelected(false)
			$UnitMenu.visible = false
			$Targets.hideTargets()
			selectedUnits = []

func _on_Button_button_down():
	$LaunchStrike.launchStrikeOnTargets($Targets.getTargets())

func OnUnitSelected(node):
	node.setSelected(true)
	$UnitMenu.visible = true
	selectedUnits.append(node);
	$Targets.showTargets(selectedUnits)
	
func TargetPressed():
	unitAction = UnitActions.TargetAction

func OnNodeCreated(_type, _obj) -> void:
	_obj.connect("targetReached", self, "OnTargetReached")

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
