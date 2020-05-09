extends Node

var unitCollection = []

func addUnit(_unit):
	# Connect Signal
	_unit.connect("clicked", get_parent(), "OnUnitSelected")
	
	add_child(_unit)
