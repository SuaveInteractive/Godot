extends Control

#onready var nav_2d : Navigation2D = $"../World Map/Navigation2D"

onready var selectedNode 

func _ready():
	Signals.connect("UnitsSetlected", self, "OnUnitsSetlected")

func _unhandled_input(_event : InputEvent) -> void:	
	pass
	
func OnUnitsSetlected(units: Array) -> void:
	if units.empty():
		visible = false
	else:
		visible = true
	

