extends Area2D

signal targetReached(target, hits)

var moveSpeed : float = 40.0
var target : Vector2 = Vector2(-1, -1) setget setTarget, getTarget

func _ready():
	pass

func setTarget(_target : Vector2):
	target = _target

func getTarget() -> Vector2:
	return target
	
func _process(_delta):
	var distance = moveSpeed * _delta;
	moveAlongPath(distance)

func moveAlongPath(_distance):
	var distanceToTarget = position.distance_to(target)
	if distanceToTarget > _distance:
		position = position.linear_interpolate(target, _distance / distanceToTarget)
	else:
		var hits = get_overlapping_areas()
		emit_signal("targetReached", target, hits)
		queue_free()

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
