extends Node2D

var WorldScene = preload("res://World/World2.tscn")

func _ready():
	var world = WorldScene.instance()
	world.get_node("World Controller").loadWorldScene("res://Data/World/WorldInformation_002.tres")
	add_child(world)
