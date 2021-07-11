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
		
func createPath(navigationMesh, fromPos, toPos) -> void:
	var newPath = navigationMesh.get_simple_path(fromPos, toPos)
	newPath.remove(0);
	path = newPath
	
	
func save():
	var saveDict = {
		"path": var2str(path)
		}
	return saveDict
	

func load(dic):
	path = str2var(dic["path"])
