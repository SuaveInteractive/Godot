extends Node

const WorldInformationScript = preload("res://GameLogic/WorldInformation.gd")

export(Resource) var WorldInformation

func _ready():
	WorldInformation = WorldInformationScript.new()
