extends Node2D
class_name DebugMultiLine2D

var points : PoolVector2Array = PoolVector2Array()
var color : Color = Color.red

func _ready():
	z_index = 99
	
func _init(points : PoolVector2Array = PoolVector2Array()):
	self.points = points

func _draw():
	draw_polyline  (points, color, 2.0)
