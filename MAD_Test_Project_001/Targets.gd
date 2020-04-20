extends Node

var targets = {}

var targetScene = load("res://Target.tscn")

func addTarget(_node : Node, _target : Vector2):
	if targets.has(_node) == false:
		targets[_node] = []
	targets[_node].append(_target)
	
func getTargets() -> Dictionary:
	return targets
	
func getTargetsForNode(_node : Node) -> Array:
	return targets[_node]
	
func showTargets(_nodeList : Array):
	for node in _nodeList:
		var nodeTargets = targets.get(node)
		if nodeTargets != null:
			for target in nodeTargets:
				var scene_instance = targetScene.instance()
				scene_instance.position = target
				scene_instance.set_name("target")
				add_child(scene_instance)

