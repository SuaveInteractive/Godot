extends Node

var missileScene = load("res://Missile.tscn")

func _process(delta):
	pass

func launchStrikeOnTargets(_targetList : Dictionary):
	for node in _targetList:
		var targets = _targetList[node]
		for target in targets:
			var missile = missileScene.instance()

			missile.set_name("missile")
			missile.setTarget(target)
			missile.position = node.position
			add_child(missile)
			
			
			
	
