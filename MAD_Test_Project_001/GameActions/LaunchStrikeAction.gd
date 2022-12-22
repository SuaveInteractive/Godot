extends Node

var worldController : Node

func _init(parameters):
	worldController = parameters.WorldController
	
	launchStrikeOnTargets(worldController.getTargets())

func _process(_delta):
	pass

func launchStrikeOnTargets(_targetList : Dictionary):
	for instanceID in _targetList:
		var targets = _targetList[instanceID]
		for target in targets:
			var from = worldController.getPosition(instanceID)
			worldController.launchMissile(from, target)
			
			
			
	
