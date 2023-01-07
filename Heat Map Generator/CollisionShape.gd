extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var DetectionShape : Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	DetectionShape = Node2D.new()
	
	#connect("draw", self, "OnDraw")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
#func _draw():
	#draw_circle(Vector2(300, 300), 10, Color(0, 1, 0))
	
	#var texture = ViewportTexture.new()
	#texture.draw($Area2D, Vector2(0, 0))
	
#func OnDraw():
	#DetectionShape.draw_circle(Vector2(300, 300), 10, Color(0, 1, 0))
