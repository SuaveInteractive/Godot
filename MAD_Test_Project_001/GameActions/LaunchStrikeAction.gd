extends "res://GameActions/GameAction.gd"

var worldController : Node

func _init(parameters):
	worldController = parameters.WorldController
	
	launchStrikeOnTargets(worldController.getTargetsForCountry(parameters.ControllingCountry))

func _process(_delta):
	pass

func launchStrikeOnTargets(targetors : Array):
	for targetor in targetors:
		var targets = targetor.targets
		for target in targets:
			var from = targetor.targetor.position
			worldController.launchMissile(from, target)
			
	EndAction()
	
