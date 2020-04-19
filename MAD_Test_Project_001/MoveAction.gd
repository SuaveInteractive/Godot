extends Node

onready var nav_2d : Navigation2D = $"../World Map/Navigation2D"

func MoveNodesToPosition(_position, _nodeList) -> void:
	for node in _nodeList:
		var newPath = nav_2d.get_simple_path(node.global_position, _position)
		newPath.remove(0);
		node.path = newPath
