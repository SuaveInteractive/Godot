extends Node

var cityScene = load("res://City.tscn")
var submarineScene = load("res://Submarine.tscn")

func createGame(_parent):
	# Cities
	var cityInstance = cityScene.instance()
	cityInstance.position = Vector2(190, 190)
	cityInstance.set_name("city_1")
	_parent.add_child(cityInstance)
	
	cityInstance = cityScene.instance()
	cityInstance.position = Vector2(639, 427)
	cityInstance.set_name("city_2")
	_parent.add_child(cityInstance)
	
	# Units
	var submarineInstance = submarineScene.instance()
	submarineInstance.position = Vector2(630, 130)
	submarineInstance.set_name("submarine_1")
	get_node("../Units").addChildMethod(submarineInstance)
	
