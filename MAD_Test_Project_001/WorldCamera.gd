extends Camera2D

func _ready():
	pass

func _process(_delta):
	# Camera Zoom
	#if Input.is_mouse_button_pressed("MoveCamera_ZoomIn"):
	#	pass
		
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
	
	self.position  = self.position  + (movementVec * _delta) * 240
