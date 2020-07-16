extends Node

var targetScene = load("res://GameEntities/Target/Target.tscn")

func addTarget(_owner : Node, _target : Vector2):
	var targetInstance = targetScene.instance()
	targetInstance.targetOwner = _owner
	targetInstance.position = _target
	targetInstance.set_name("target")
	add_child(targetInstance)
	
func getTargets() -> Dictionary:
	var targets = {}
	for i in get_children():
		if targets.has(i.targetOwner) == false:
			targets[i.targetOwner] = []
		targets[i.targetOwner].append(i.position)
	return targets
	
func getTargetsForNode(_owner : Node) -> Array:
	var targetArray = []
	for target in get_children():
		if target.owner == owner:
			targetArray.append(target)
	return targetArray
	
func showTargets(_ownerList : Array):
	for target in get_children():
		for targetOwner in _ownerList:
			if target.targetOwner == targetOwner:
				target.visible = true

func hideTargets():
	for target in get_children():
		target.visible = false
