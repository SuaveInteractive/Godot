extends Node2D

var lineStart : Vector2 = Vector2()
var lineEnd : Vector2 = Vector2()

func _ready():
	z_index = 99
	
func _init(start : Vector2 = Vector2(0, 0), end : Vector2 = Vector2(0, 0)):
	lineStart = start
	lineEnd = end

func _draw():
	draw_line(lineStart, lineEnd, Color.red)
