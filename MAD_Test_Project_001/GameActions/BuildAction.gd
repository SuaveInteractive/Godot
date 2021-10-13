extends Node

var MouseIcon : Sprite = null
var BuildArea : PoolVector2Array = PoolVector2Array()

var debugRecScript = load("res://Debug/DebugRectangle2D.gd")
var debugRec : Node2D = null

var debugPolylineScript = load("res://Debug/DebugPolyline2D.gd")
var debugPolyline : Node2D = null

# Work out if the build position is within the country boundary
# https://docs.godotengine.org/en/stable/classes/class_geometry.html
#var ClipArray = Geometry.clip_polygons_2d($Area2D/CollisionPolygon2D.polygon, 

func _ready():
	"""
	Debug
	"""
	debugRec = debugRecScript.new()
	debugRec.Size = MouseIcon.get_rect().size
	add_child(debugRec)
	
	debugPolyline = debugPolylineScript.new()
	var polyPoints = PoolVector2Array(BuildArea)
	polyPoints.append(BuildArea[0])
	debugPolyline.points = polyPoints
	add_child(debugPolyline)

func _init(parameters):
	BuildArea = parameters.BuildArea
	MouseIcon = Sprite.new()
	MouseIcon.z_index = 1
	MouseIcon.texture = load("res://GameEntities/Silo/silo.png")
	add_child(MouseIcon)

func _process(_delta):
	MouseIcon.position = get_viewport().get_mouse_position()
	
	var clipPoly : PoolVector2Array = PoolVector2Array()
	var iconRec : Rect2 = MouseIcon.get_rect()
	var iconPos : Vector2 = MouseIcon.position
	
	var topleft : Vector2 = Vector2(iconPos.x - iconRec.size.x / 2, iconPos.y - iconRec.size.y / 2)
	var topRight : Vector2 = Vector2(iconPos.x + iconRec.size.x / 2, iconPos.y - iconRec.size.y / 2)
	var Bottomleft : Vector2 = Vector2(iconPos.x - iconRec.size.x / 2, iconPos.y + iconRec.size.y / 2)
	var BottomRight : Vector2 = Vector2(iconPos.x + iconRec.size.x / 2, iconPos.y + iconRec.size.y / 2)
	
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
	else:
		debugRec.color = Color.red
		
	debugRec.update()
	debugPolyline.update()
	
func _unhandled_input(event : InputEvent) -> void:	
	if not event is InputEventMouseButton:
		return
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		pass
