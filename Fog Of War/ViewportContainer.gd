extends ViewportContainer

# Object to hold the data of an image
var image : ImageTexture = null  
# Object to create a texture from image data
var sampleTexture : ImageTexture = null

var width : int = 0
var height : int = 0

var greyImage : Image = null  
var maskImage : Image = null  

var counter : float = 0.0

# ***** Modify Texture *****
# https://godotengine.org/qa/53368/modifying-a-texture-at-run-time
# https://godotshaders.com/shader/double-texture-blend-2d/
# https://www.youtube.com/watch?v=zkMSbQoUd9o

func _ready():
	#createMaskTexture()
	
	#Need to make sure the Noise Texture has been created before calling get_data()
	#https://docs.godotengine.org/en/stable/classes/class_noisetexture.html?highlight=NoiseTexture
	yield(get_tree(), "idle_frame")
	
	#image = $Viewport/Intelligence.texture.get_data()	
	#var format = image.get_format()
	#createMaskTextureFromImage(image)
	
func createMaskTexture():
	# https://www.reddit.com/r/godot/comments/72eei6/create_imagetexture_via_code/
	#image = Image.new()
	
	createMaskTextureFromImage(image)
	
	# Set the shader uniform
	self.material.set_shader_param("mask", sampleTexture)

func createMaskTextureFromImage(inputImage):
	width = get_viewport().size.x
	height = get_viewport().size.y
	
	sampleTexture = ImageTexture.new()
	sampleTexture.create_from_image(inputImage)
	
#	greyImage = Image.new()
#	greyImage.create(inputImage.get_width(), inputImage.get_height(), inputImage.has_mipmaps (), inputImage.get_format())
#	greyImage.lock()
#	#greyImage.fill(Color(0.21, 0.71, 0.07, 1))
#	greyImage.fill(Color(1, 1, 1, 0.01))
#	greyImage.unlock()
	
	var tmaskImage = Image.new()
	#maskImage.create(inputImage.get_width(), inputImage.get_height(), inputImage.has_mipmaps (), inputImage.get_format())
	tmaskImage.create(600, 600, false, Image.FORMAT_RGBA8)
	tmaskImage.lock()
	#greyImage.fill(Color(0.21, 0.71, 0.07, 1))
	tmaskImage.fill(Color(1, 0, 0, 1))
	tmaskImage.unlock()
	
	# Set the shader uniform
	setSampleTexture(sampleTexture)
	
	var imgTexture = ImageTexture.new()
	imgTexture.create_from_image(tmaskImage)
	#$Viewport/GreyImage.texture = imgTexture
	
func setSampleTexture(inputImage):
	sampleTexture = ImageTexture.new()
	sampleTexture.create_from_image(inputImage)
	#sampleTexture.create_from_image(inputImage, ImageTexture.FLAG_CONVERT_TO_LINEAR)
	#self.material.set_shader_param("mask", sampleTexture)
	
func setBlendImage(blendImage):
	image = ImageTexture.new()
	image.create_from_image(blendImage)
	#image.create_from_image(blendImage, ImageTexture.FLAG_CONVERT_TO_LINEAR)

#func _process(delta):
#	counter = counter + delta
#	if counter > 2.0:
#		#https://docs.godotengine.org/en/stable/classes/class_poolbytearray.html
#		var imageData : PoolByteArray = sampleTexture.get_data().save_png_to_buffer()
#		#var imageData_array = imageData[0]
#
#		for i in imageData.size():
#			var testData = imageData[i]
#			#imageData_array[i] = imageData_array[i] + 1
#			imageData[i] = testData + 50
#
#		#imageData[0] = imageData_array
#
#		sampleTexture.get_data().load_png_from_buffer(imageData)
#
#
#
#		if image:
#			var format1 = sampleTexture.get_data().get_format()
#			var format2 = image.get_data().get_format()
#
#			#sampleTexture.get_data().blend_rect(image.get_data(), image.get_data().get_used_rect(), Vector2(0,0))
#			#image.blend_rect(greyImage, greyImage.get_used_rect(), Vector2(0,0))
#			#image.blend_rect_mask (greyImage, maskImage, greyImage.get_used_rect(), Vector2(0,0))
#			#sampleTexture.set_data(image)

#func _process(delta):
#	if image:
#		var changeInColour : float = delta * 100
#		var data = image.get_data()
#		for x in data.size():
#			var val = data[x]
#			val = val + changeInColour
#			data[x] = val
#
#		imageTexture.set_data(image)

#func _process(delta):
#	if image:
#		var changeInColour : float = delta
#		image.lock()
#		for x in width:
#			for y in height:
#				var val : float = image.get_pixel(x, y).r
#				val = val + changeInColour
#				val = clamp(val, 0, 1)
#				image.set_pixel(x, y, Color(val, 0, 0, 1))
#
#		image.unlock()
#		imageTexture.set_data(image)
