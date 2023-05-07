extends "res://GameCommand/GameCommand.gd"

var Country : Node = null
var Targetors : Array = []
var WorldController : Node = null

func _init():
	SetName("Launch_Strike_Command")

func execution() -> bool:
	for targetor in Targetors:
		var targets = targetor.targets
		for target in targets:
			var from = targetor.targetor.position
			WorldController.launchMissile(Country, from, target)
	
	return true
