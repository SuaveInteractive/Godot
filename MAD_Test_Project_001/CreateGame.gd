extends Node

var cityScene = load("res://City.tscn")
var submarineScene = load("res://Submarine.tscn")

func createGame(_parent):
	# Cities
	var cityInstance = cityScene.instance()
	cityInstance.position = Vector2(190, 190)
	cityInstance.set_name("city")
	_parent.add_child(cityInstance)
	
	# Units
	var submarineInstance = submarineScene.instance()
	submarineInstance.position = Vector2(630, 130)
	submarineInstance.set_name("submarine")
	get_node("../Units").addChildMethod(submarineInstance)
	
