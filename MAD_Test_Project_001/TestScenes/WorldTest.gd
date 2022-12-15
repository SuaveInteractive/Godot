extends Node2D

var WorldScene = preload("res://World/World.tscn")

func _ready():
	var world = WorldScene.instance()
	world.get_node("World Controller").loadWorld("res://Data/World/WorldInformation_003.tres")
	add_child(world)
