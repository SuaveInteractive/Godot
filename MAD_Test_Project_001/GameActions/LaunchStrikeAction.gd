extends Node

var worldController : Node

func _init(parameters):
	worldController = parameters.WorldController
	
	launchStrikeOnTargets(worldController.getTargets())

func _process(_delta):
	pass

func launchStrikeOnTargets(targetors : Array):
	for targetor in targetors:
		var targets = targetor.targets
		for target in targets:
			var from = targetor.targetor.position
			worldController.launchMissile(from, target)
			
			
			
	
