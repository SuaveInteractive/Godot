extends Node

var Targets : Array = [] setget , getTargets

func addTarget(target):
	Targets.push_back(target)
	
func getTargets():
	return Targets
