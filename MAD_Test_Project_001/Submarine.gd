extends Area2D

var path = []
var moveSpeed : float = 20.0
var selected : bool = false setget setSelected, getSelected

signal clicked(node)

func _ready():
	$Selected.visible = false
	
func _process(_delta):
	var distance = moveSpeed * _delta;
	moveAlongPath(distance)
	
func setSelected(_selected : bool):
	selected = _selected
	$Selected.visible = _selected
	
func getSelected() -> bool:
	return selected
	
func moveAlongPath(_distance):
	var lastPos = position
	for i in range(path.size()):
		var distanceToNext = lastPos.distance_to(path[0])
		if _distance <= distanceToNext:
			position = lastPos.linear_interpolate(path[0], _distance / distanceToNext)
			break
		elif _distance < 0.0:
			position = path[0]
			set_process(false)
			break
			
		_distance -= distanceToNext
		lastPos = path[0]
		path.remove(0)

func _on_Submarine_input_event(viewport, event, shape_idx):
	if not event is InputEventMouseButton:
		return
	if not Input.is_mouse_button_pressed(BUTTON_LEFT):
		return
	
	if event.button_index == BUTTON_LEFT:
		emit_signal("clicked", self)
		
func save():
	var save_dict = {
		"filename" : get_filename(),
		"name" : name,
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
	}
	return save_dict

func load(_dic):
	position.x = _dic["pos_x"]
	position.y = _dic["pos_y"]
