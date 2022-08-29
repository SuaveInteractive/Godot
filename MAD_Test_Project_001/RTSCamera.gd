extends Camera2D


# Need to define MoveCamera_Left, MoveCamera_Right, MoveCamera_Up, MoveCamera_Down 
# to have the camera work.
# Needs to be made Current to work

export var CameraSpeed : int = 240

# Zoom Parameters
export var ZoomLimit_speed : float = 1.0
export var ZoomLimit_In : Vector2 = Vector2(0.1, 0.1)
export var ZoomLimit_Out : Vector2 = Vector2(1.0, 1.0)

# On Ready Variables
onready var viewport_size = get_viewport().size

func _ready():
	limit_right = viewport_size.x
	limit_bottom = viewport_size.y

func _process(_delta):
	# Zoom
	# https://github.com/godotengine/godot/issues/36322
	var zoomDelta = zoom
	
	if Input.is_action_just_released("MoveCamera_ZoomIn"):
		zoomDelta.x = zoomDelta.x + ZoomLimit_speed * _delta
		zoomDelta.y = zoomDelta.y + ZoomLimit_speed * _delta
	if Input.is_action_just_released("MoveCamera_ZoomOut"):
		zoomDelta.x = zoomDelta.x - ZoomLimit_speed * _delta
		zoomDelta.y = zoomDelta.y - ZoomLimit_speed * _delta
		
	zoomDelta.x = clamp(zoomDelta.x, ZoomLimit_In.x, ZoomLimit_Out.x)
	zoomDelta.y = clamp(zoomDelta.y, ZoomLimit_In.y, ZoomLimit_Out.y)
	zoom = zoomDelta
	
	# Camera Position
	var movementVec : Vector2 = Vector2(0.0, 0.0)
	
	if Input.is_action_pressed("MoveCamera_Left"):
		movementVec.x = -1;
	if Input.is_action_pressed("MoveCamera_Right"):
		movementVec.x = 1;
	if Input.is_action_pressed("MoveCamera_Up"):
		movementVec.y = -1;
	if Input.is_action_pressed("MoveCamera_Down"):
		movementVec.y = 1;
	
	movementVec = movementVec.normalized()
	
	var pos = self.position
	pos = pos + (movementVec * _delta) * CameraSpeed
	
	# https://github.com/godotengine/godot/issues/62441
	var x = zoom.x*viewport_size.x/2
	var y = zoom.y*viewport_size.y/2
	pos.x = clamp(pos.x, limit_left+x, limit_right-x)
	pos.y = clamp(pos.y, limit_top+y, limit_bottom-y)
	
	self.position = pos
