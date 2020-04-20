extends Area2D

signal targetReached(target)

var moveSpeed : float = 40.0
var target : Vector2 = Vector2(-1, -1) setget setTarget, getTarget

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
		emit_signal("targetReached", target)
		queue_free()
