extends Node

# Scene organization and Dependency Injection
# https://docs.godotengine.org/en/3.1/getting_started/workflow/best_practices/scene_organization.html

export var PositionNode: NodePath = ".."
var path : Array = []
export var moveSpeed : float = 20.0

func _process(_delta):
	var distance = moveSpeed * _delta;

	var lastPos = get_node(PositionNode).position
	for _i in range(path.size()):
		var distanceToNext = lastPos.distance_to(path[0])
		if distance <= distanceToNext:
			get_node(PositionNode).position = lastPos.linear_interpolate(path[0], distance / distanceToNext)
			break
		elif distance < 0.0:
			get_node(PositionNode).position = path[0]
			set_process(false)
			break
			
		distance -= distanceToNext
		lastPos = path[0]
		path.remove(0)
		
func createPath(mapRID, fromPos, toPos) -> void:
	var newPath = Navigation2DServer.map_get_path(mapRID, fromPos, toPos, true)
	path = newPath

