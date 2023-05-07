extends "res://GameActions/GameAction.gd"

var worldController : Node = null

func _init(parameters):
	worldController = parameters.WorldController
	
	launchStrikeOnTargets(parameters.ControllingCountry, worldController.getTargetsForCountry(parameters.ControllingCountry))

func _process(_delta):
	pass

func launchStrikeOnTargets(country, targetors : Array):
	GameCommands.LaunchStrikeCommand.Country = country
	GameCommands.LaunchStrikeCommand.Targetors = targetors
	GameCommands.LaunchStrikeCommand.WorldController = worldController
	GameCommands.LaunchStrikeCommand.execute()
			
	EndAction()
	
