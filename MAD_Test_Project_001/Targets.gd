extends Node

# Classes who want to display Targets via this class need to implement a getTargets 
#	func that returns a list of Position2 representing targets in world space

var targetScene = load("res://GameEntities/Target/Target.tscn")
	
func getTargets() -> Dictionary:
	var Targetors = get_tree().get_nodes_in_group("Targetor")
	var Return_Targets = {}
	for targetor in Targetors:
		Return_Targets[targetor] = []
		var targetNode = targetor.get_node("TargetNode")
		for targets in targetNode.getTargets():
			Return_Targets[targetor].append(targets)
	return Return_Targets
	
func getTargetsForNode(_owner : Node) -> Array:
	var targetArray = []
	for target in get_children():
		if target.owner == owner:
			targetArray.append(target)
	return targetArray
	
func showTargets(ownerList : Array):
	for targetOwner in ownerList:
		var targetNode = targetOwner.get_node("TargetNode")
		for target in targetNode.getTargets():
			var targetInstance = targetScene.instance()
			targetInstance.position = target
			targetInstance.set_name("target")
			add_child(targetInstance)

func hideTargets():
	for target in get_children():
		target.queue_free()
