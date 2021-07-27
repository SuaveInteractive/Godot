extends Node

var controllingCountry = null
var updateTick := 30
var currentTick := 30

var currentPlans := []

var heatMap : Array

#TEMP
var addedScriptedBehaviour := false

func _init(name, country):
	self.set_name(name)
	controllingCountry = country

func _process(_delta):
	currentTick = currentTick + 1
	if currentTick >= updateTick:
		currentTick = 0
		runAI()

func runAI() -> void:
	#createHeatMap()
	
	"""
	Setup the scripted behaviour
	"""
	if not addedScriptedBehaviour:
		addedScriptedBehaviour = true
		var node = null
		for i in controllingCountry.get_child_count():
			var k = controllingCountry.get_child(i) as Node
			if k.name == "submarine_1":
				node = k
				break
		currentPlans.append({"Command":"Move_Command", "args":{"node":node, "position":"Vector2( 500, 100 )"}})
		
	"""
	Execute the plan
	"""
	if currentPlans.size() > 0:
		var command = currentPlans.pop_front()
		GameCommands.MoveCommand.Navigation_Mesh = get_tree().get_root().get_node("/root/Game/WorldMap/Navigation2D")
		GameCommands.MoveCommand.Position_To = Vector2(500, 100)
		GameCommands.MoveCommand.Selected_Units = [command.args.node]
		GameCommands.MoveCommand.execute()
	

func createHeatMap():
	# delete and recreate the heat map
	heatMap.clear()

