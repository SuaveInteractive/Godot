extends Node

var targets = {}

var targetScene = load("res://Target.tscn")
var targetsArray = []

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
				var targetInstance = targetScene.instance()
				targetInstance.position = target
				targetInstance.set_name("target")
				add_child(targetInstance)
				
				targetsArray.append(targetInstance)

func hideTargets():
	for target in targetsArray:
		target.queue_free()
	targetsArray = []

func save():
	var save_dict = {
		"filename" : get_filename(),
		"name" : name,
		"parent" : get_parent().get_path(),
	}
	return save_dict
	
func load(_dic):
	pass
