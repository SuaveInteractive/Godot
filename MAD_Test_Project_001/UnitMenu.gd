extends Control

#onready var nav_2d : Navigation2D = $"../World Map/Navigation2D"

onready var selectedNode 

func _ready():
	Signals.connect("UnitSelected", self, "OnUnitsSelected")

func _unhandled_input(_event : InputEvent) -> void:	
	pass
	
func OnUnitsSelected(units: Array) -> void:
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

