extends Node

var Targets : Array = [] setget , getTargets

func addTarget(target):
	Targets.push_back(target)
	
func getTargets():
	return Targets

func _on_Selection_EntityDeselected(entity):
	for child in get_children():
		child.visible = false

func _on_Selection_EntitySelected(entity):
	for child in get_children():
		child.visible = true
