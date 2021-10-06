extends Node2D
class_name DebugRectangle2D

var Size : Vector2 = Vector2()
var Position : Vector2 = Vector2()
var color : Color = Color.red

func _ready():
	z_index = 99
	
func _init(pos : Vector2 = Vector2(0, 0), size : Vector2 = Vector2(1, 1)):
	Position = pos
	Size = size

func _draw():
	draw_line(Position, Vector2(Position.x + Size.x, Position.y), color)
	draw_line(Vector2(Position.x + Size.x, Position.y), Vector2(Position.x + Size.x, Position.y + Size.y), color)
	draw_line(Vector2(Position.x + Size.x, Position.y + Size.y), Vector2(Position.x, Position.y + Size.y), color)
	draw_line(Vector2(Position.x, Position.y + Size.y), Position, color)
