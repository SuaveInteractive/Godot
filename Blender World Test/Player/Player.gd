extends Spatial

#	player_move_forward (w)
#	player_move_backward (s)
# 	player_move_strafe_left (a)
# 	player_move_strafe_right (d)
# 	player_move_fast (l-shift)

# https://randommomentania.com/2018/05/godot-single-player-fps-part-1/

# Declare member variables here. Examples:
export var gravity : Vector3 = Vector3(0,-9.8,0)
export var walkSpeed : float = 8.0
export var runSpeed : float = 15.0

var linear_velocity=Vector3()

# Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta):
	var forward_movement : float = Input.get_action_strength("player_move_forward") - Input.get_action_strength("player_move_backward")
	var side_movement : float = Input.get_action_strength("player_move_strafe_right") - Input.get_action_strength("player_move_strafe_left")
		
	var motion : Vector3 = Vector3(forward_movement, 0, side_movement).normalized()
	
	var cam_xform = $KinematicBody/FirstPersionCamera.get_global_transform()
	
	var lv = linear_velocity
	var up = -gravity.normalized() # (up is against gravity)
		
	# Apply Gravity
	lv += gravity * _delta
		
	var dir = Vector3()
	if $KinematicBody.is_on_floor():
		dir += -cam_xform.basis.z * forward_movement
		dir += cam_xform.basis.x * side_movement
	
	
	var vv = up.dot(lv) # Vertical velocity
	var hv = lv - up*vv # Horizontal velocity
	
	var hdir = hv.normalized() # Horizontal direction
	var hspeed = hv.length() # Horizontal speed
	
	if Input.get_action_strength("player_move_fast") > 0.1:
		hspeed = runSpeed	
	else:
		hspeed = walkSpeed
	
	var target_dir = (dir - up*dir.dot(up)).normalized()
	
	hdir = target_dir
	hv = hdir*hspeed
	
	lv = hv + up*vv
	
	linear_velocity = $KinematicBody.move_and_slide(lv,up)	