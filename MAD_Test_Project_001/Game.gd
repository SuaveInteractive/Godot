extends Node2D

# https://www.youtube.com/watch?v=Ad6Us73smNs

onready var nav_2d : Navigation2D = $"World Map/Navigation2D"
onready var line_2d : Line2D = $Line2D
onready var submarine : Sprite = $Submarine

class_name Submarine


var path = []
var moveSpeed : float = 20.0

func _unhandled_input(event : InputEvent) -> void:
		
	if not event is InputEventMouseButton:
		return
	if not Input.is_mouse_button_pressed(BUTTON_LEFT):
		return
	
	if event.button_index == BUTTON_LEFT:
		var loc = event.get_global_position()
		var newPath = nav_2d.get_simple_path(submarine.global_position, loc)
		newPath.remove(0);
		
		path = newPath
		
		# draw the path
		line_2d.clear_points()
		line_2d.add_point(submarine.global_position)
		for i in range(path.size()):
			line_2d.add_point(path[i])
		
		
func _process(_delta):
	var distance = moveSpeed * _delta;
	moveAlongPath(distance)

func moveAlongPath(_distance):
	var lastPos = $Submarine.position
	for i in range(path.size()):
		var distanceToNext = lastPos.distance_to(path[0])
		if _distance <= distanceToNext:
			$Submarine.position = lastPos.linear_interpolate(path[0], _distance / distanceToNext)
			break
		elif _distance < 0.0:
			$Submarine.position = path[0]
			set_process(false)
			break
			
		_distance -= distanceToNext
		lastPos = path[0]
		path.remove(0)


func _on_Button_button_down():
	$Missile.position = $Submarine.position
