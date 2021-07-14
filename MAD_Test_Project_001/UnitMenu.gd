extends Control

#onready var nav_2d : Navigation2D = $"../World Map/Navigation2D"

onready var selectedNode 

func _ready():
	Signals.connect("UnitsSetlected", self, "OnUnitsSetlected")

func _unhandled_input(_event : InputEvent) -> void:	
	pass
	
func OnUnitsSetlected(units: Array) -> void:
	if units.empty():
		$Target.visible = false
		$Move.visible = false
	else:
		for unit in units:
			var targetNode = unit.get_node("TargetNode")
			if targetNode != null:
				$Target.visible = true
				
			var moveNode = unit.get_node("MoveNode")
			if moveNode != null:
				$Move.visible = true
	

