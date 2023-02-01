extends Node2D

# Object to hold the data of an image
var image : Image = null  
# Object to create a texture from image data
var imageTexture : ImageTexture = null

var width : int = 0
var height : int = 0

func _ready():
	pass

func upateTexture():
	# https://www.reddit.com/r/godot/comments/72eei6/create_imagetexture_via_code/
	image = Image.new()

	width = self.texture.get_width()
	height = self.texture.get_height()
	
	image.create(width,height,false,Image.FORMAT_R8)
	#image.create(width,height,false,Image.FORMAT_RGBA8)
	image.fill(Color(1,0,0,1))
	
	imageTexture = ImageTexture.new()
	imageTexture.create_from_image(image)
	
	DebugShapesDraw()
	
	# Set the shader uniform
	self.material.set_shader_param("mask", imageTexture)
	
	$TextureMask.texture = imageTexture

func _process(delta):
	if image:
		var changeInColour : float = delta
		image.lock()
		for x in width:
			for y in height:
				var val : float = image.get_pixel(x, y).r
				val = val + changeInColour
				val = clamp(val, 0, 1)
				image.set_pixel(x, y, Color(val, 0, 0, 1))
				
		image.unlock()
		imageTexture.set_data(image)
	
func fillRect(rect : Rect2) -> void:
	image.fill_rect(rect, Color(0, 0, 0, 0))
	imageTexture.set_data(image)
	
func fillCircle(pos : Vector2, radius : int):
	image.lock()
	for x in width:
		for y in height:
			if pos.distance_to(Vector2(x, y)) < radius:
				image.set_pixel(x, y, Color(0, 0, 0, 1))
	image.unlock()
	imageTexture.set_data(image)
	
''' DEBUG INFO'
func DebugShapesDraw() -> void:
	fillRect(Rect2(Vector2(300, 200), Vector2(300, 100)))
	fillCircle(Vector2(100, 100), 50)


