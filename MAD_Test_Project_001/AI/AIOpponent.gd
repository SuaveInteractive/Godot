extends Node

var Matrix = preload("res://Utils/Matrix.gd")

var ControllingCountry = null
var WorldController = null

var updateTick := 30
var currentTick := 30

var currentPlans := []

var heatMap : Matrix = null

#TEMP
var addedScriptedBehaviour := false

func _ready():
	heatMap = Matrix.new()

func _init(name : String = "", country : Node = null, worldController : Node = null):
	self.set_name(name)
	ControllingCountry = country
	WorldController = worldController

func _process(_delta):
	currentTick = currentTick + 1
	if currentTick >= updateTick:
		currentTick = 0
		runAI()

func runAI() -> void:
	_createHeatMap()
	_updateHeatMap()
	
	"""
	Setup the scripted behaviour
	"""
	#if not addedScriptedBehaviour:
	#	addedScriptedBehaviour = true
	#	var node = null
	#	for i in ControllingCountry.get_child_count():
	#		var k = ControllingCountry.get_child(i) as Node
	#		if k.name == "submarine_1":
	#			node = k
	#			break
	#	currentPlans.append({"Command":"Move_Command", "args":{"node":node, "position":"Vector2( 500, 100 )"}})
		
	"""
	Execute the plan
	"""
	#if currentPlans.size() > 0:
	#	var command = currentPlans.pop_front()
	#	GameCommands.MoveCommand.Navigation_Mesh = worldMap.get_node("WaterNavigation")
	#	GameCommands.MoveCommand.Position_To = Vector2(500, 100)
	#	GameCommands.MoveCommand.Selected_Units = [command.args.node]
	#	GameCommands.MoveCommand.execute()
	

func _createHeatMap():
	var worldSize = WorldController.getWorldSize()
	heatMap.resize(worldSize.x, worldSize.y)

func _updateHeatMap() -> void:
	#var detectionArea = ControllingCountry.getDetectionArea()
	pass
