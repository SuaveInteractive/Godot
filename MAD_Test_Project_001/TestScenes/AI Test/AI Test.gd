extends Node

var WorldScene = preload("res://World/World.tscn")

var AIOpponent = preload("res://AI/AIOpponent.gd")
var AIController = preload("res://AI/AI Controller.gd")

func _ready():
	var world = WorldScene.instance()	
	var worldController = world.get_node("World Controller")
	add_child(world)
	worldController.loadWorld("res://Data/World/WorldInformation_003.tres")
	
	" Create the AI Opponents "
	var aiOpponent_1 = AIOpponent.new("AI Opponent 1", worldController.getCountries()[0], worldController)	
	#var aiOpponent_2 = AIOpponent.new("AI Opponent 2", worldController.getCountries()[1], worldController)	
	
	var aiController = AIController.new()	
	aiController.addAIOpponent(aiOpponent_1)
	#aiController.addAIOpponent(aiOpponent_2)
	
	add_child(aiController)


