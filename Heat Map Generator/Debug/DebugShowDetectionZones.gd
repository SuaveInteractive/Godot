extends Node2D 

func _ready():
	pass

func _init():
	self.name = "Debug Detection Zones"
		
func getGUIControl():
	var checkbutton = CheckButton.new()
	checkbutton.name = "Show Detection Zones"
	checkbutton.text = "Show Detection Zones"	
	
	checkbutton.connect("toggled", self, "OnButtonToggle")
	
	return checkbutton;
	
func OnButtonToggle(_toggle):
	var viewportWidth = get_viewport().get_texture().get_width()
	var viewportHeight = get_viewport().get_texture().get_height()
	
	var combImage = Image.new()
	combImage.create(viewportWidth, viewportHeight, false, Image.FORMAT_RGBA8)
	
	var sourceImg = Image.new()
	sourceImg.create(viewportWidth, viewportHeight, false, Image.FORMAT_RGBA8)
	sourceImg.fill(Color(1, 0, 0, 1))
		
	var detectorNodes = get_tree().get_nodes_in_group("Detectors")
	for node in detectorNodes:
		var viewportTexture = node.get_texture()
		var maskImage = node.get_texture().get_data() # MAKE SURE THE VIEWPORT HAS TRANSPARENT BACKGROUND SET TO TRUE
		combImage.blend_rect_mask (sourceImg, maskImage, Rect2(0, 0, viewportTexture.get_width(), viewportTexture.get_height()), Vector2(0, 0))
		
	var combTexture = ImageTexture.new()
	combTexture.create_from_image(combImage)
	
	var sprite = Sprite.new()
	sprite.texture = combTexture
	sprite.z_index = 99
	add_child(sprite)
	
