extends "res://GameActions/GameAction.gd"

var worldController : Node

func _init(parameters):
	worldController = parameters.WorldController
	
	launchStrikeOnTargets(parameters.ControllingCountry, worldController.getTargetsForCountry(parameters.ControllingCountry))

func _process(_delta):
	pass

func launchStrikeOnTargets(country, targetors : Array):
	for targetor in targetors:
		var targets = targetor.targets
		for target in targets:
			var from = targetor.targetor.position
			worldController.launchMissile(country, from, target)
			
	EndAction()
	
