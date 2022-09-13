extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# https://www.reddit.com/r/godot/comments/72eei6/create_imagetexture_via_code/
	var imageTexture = ImageTexture.new()
	var dynImage = Image.new()
	
	dynImage.create(800,600,false,Image.FORMAT_R8)
	dynImage.fill(Color(1,0,0,1))
	
	var rect = Rect2(Vector2(100, 100), Vector2(300, 100))
	dynImage.fill_rect(rect, Color(0, 0, 0, 0))
	
	imageTexture.create_from_image(dynImage)
	self.texture = imageTexture
	
	# Set the shader uniform
	$WorldTexture.material.set_shader_param("mask", imageTexture)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
