extends Node

var MouseIcon : Sprite = null
var BuildArea : PoolVector2Array = PoolVector2Array()
var ValidBuildArea : bool = false
var Params = null

var debugRecScript = load("res://Debug/DebugRectangle2D.gd")
var debugRec : Node2D = null

var debugPolylineScript = load("res://Debug/DebugPolyline2D.gd")
var debugPolyline : Node2D = null

# Work out if the build position is within the country boundary
# https://docs.godotengine.org/en/stable/classes/class_geometry.html

func _ready():
	"""
	Debug
	"""
	debugRec = debugRecScript.new()
	debugRec.Size = MouseIcon.texture.get_size() * MouseIcon.scale
	add_child(debugRec)
	
	debugPolyline = debugPolylineScript.new()
	var polyPoints = PoolVector2Array(BuildArea)
	polyPoints.append(BuildArea[0])
	debugPolyline.points = polyPoints
	add_child(debugPolyline)

func _init(parameters):
	Params = parameters
	BuildArea = parameters.BuildCountry.get_node("Boarder").polygon
	MouseIcon = Sprite.new()
	MouseIcon.z_index = 10
	MouseIcon.texture = load(parameters.Texture)
	MouseIcon.scale = parameters.Scale
	add_child(MouseIcon)

"""
https://godotforums.org/d/21957-camera-messing-with-getting-the-mouse-position

"""

func _process(_delta):
	# Need to get the Mouse local position
	MouseIcon.position = get_parent().get_parent().get_global_mouse_position() 
		
	var clipPoly : PoolVector2Array = PoolVector2Array()
	var iconSize : Vector2 = MouseIcon.texture.get_size() * MouseIcon.scale
	var iconPos : Vector2 = MouseIcon.position
	
	var topleft : Vector2 = Vector2(iconPos.x - iconSize.x / 2, iconPos.y - iconSize.y / 2)
	var topRight : Vector2 = Vector2(iconPos.x + iconSize.x / 2, iconPos.y - iconSize.y / 2)
	var Bottomleft : Vector2 = Vector2(iconPos.x - iconSize.x / 2, iconPos.y + iconSize.y / 2)
	var BottomRight : Vector2 = Vector2(iconPos.x + iconSize.x / 2, iconPos.y + iconSize.y / 2)
	
	clipPoly.append(topleft)
	clipPoly.append(topRight)
	clipPoly.append(BottomRight)
	clipPoly.append(Bottomleft)
	
	"""
	Debug
	"""
	debugRec.Position = topleft
	var result : Array = Geometry.clip_polygons_2d(clipPoly, BuildArea)
	if result.empty():
		debugRec.color = Color.green
		ValidBuildArea = true
	else:
		debugRec.color = Color.red
		ValidBuildArea = false
		
	debugRec.update()
	debugPolyline.update()
	
func _unhandled_input(event : InputEvent) -> void:	
	if not event is InputEventMouseButton:
		return
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and ValidBuildArea == true:
		GameCommands.BuildCommand.Position_Build = MouseIcon.position
		GameCommands.BuildCommand.Build_Info = Params
		GameCommands.BuildCommand.execute()
		get_tree().set_input_as_handled()
		
		Signals.emit_signal("EndGameAction")
