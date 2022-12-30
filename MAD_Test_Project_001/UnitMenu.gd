extends Control

func _ready():
	pass

func _unhandled_input(_event : InputEvent) -> void:	
	pass
	
func ProcessUnitsSelection(units: Array) -> void:
	if units.empty():
		$Target.visible = false
		$Move.visible = false
	else:
		for unit in units:
			if unit.has_method("isStructureConstructing") and unit.isStructureConstructing():
				pass
			else:
				if unit.has_node("TargetNode"):
					$Target.visible = true
					
				if unit.has_node("MoveNode"):
					$Move.visible = true

