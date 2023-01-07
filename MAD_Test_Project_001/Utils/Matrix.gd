extends Node
class_name Matrix

var Data = [[]]
var Width = 5
var Height = 5
var DefaultVal = 0 

func _init():
	resize(Width, Height)

func resize(width, height):
	Width = width
	Height = height
	
	Data.resize(Width)
	Data.fill([])
	
	for x in Width:
		Data[x].resize(Height)
		
	clear()
		
func clear():
	for x in Width:
		Data[x].fill(DefaultVal)
