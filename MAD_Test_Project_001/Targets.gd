extends Node

var targets = {}

func addTarget(_node : Node, _target : Vector2):
	targets[_node] = _target
	
func getTargets() -> Dictionary:
	return targets
	
func getTargetForNode(_node : Node):
	return targets[_node]
	
func showTargets(_nodeList : Array):
	pass
