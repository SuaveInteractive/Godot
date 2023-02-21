extends ViewportContainer

# Object to hold the data of an image
var image : Image = null  
# Object to create a texture from image data
var imageTexture : ImageTexture = null

var width : int = 0
var height : int = 0


#func _ready():
#	createMaskTexture()
#
#	#Need to make sure the Noise Texture has been created before calling get_data()
#	#https://docs.godotengine.org/en/stable/classes/class_noisetexture.html?highlight=NoiseTexture
#	yield(get_tree(), "idle_frame")
#
#	image = $Sprite.texture.get_data()	
#	createMaskTextureFromImage(image)
#
#func createMaskTexture():
#	# https://www.reddit.com/r/godot/comments/72eei6/create_imagetexture_via_code/
#	image = Image.new()
#
#	createMaskTextureFromImage(image)
#
#	# Set the shader uniform
#	self.material.set_shader_param("mask", imageTexture)
#
#func createMaskTextureFromImage(image):
#	width = get_viewport().size.x
#	height = get_viewport().size.y
#
#	imageTexture = ImageTexture.new()
#	imageTexture.create_from_image(image)
#
#	# Set the shader uniform
#	self.material.set_shader_param("mask", imageTexture)

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
