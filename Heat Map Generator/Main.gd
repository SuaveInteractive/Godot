extends Node
# https://godotengine.org/qa/19862/how-to-use-blend_rect_mask

#var DebugShowDetectionZonesScript = load("res://Debug/DebugShowDetectionZones.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	#var debugControl = DebugShowDetectionZonesScript.new()
	#DebugOverlay.addDebugControl(debugControl)
	pass

func _process(_delta):
	pass

	"""
func implementation_1():
	var combImage = Image.new()
	combImage.load("res://Dest.png")
	var combTexture = ImageTexture.new()
	
	var sourceImg = $Source.texture.get_data()
	var maskImg = $Mask.texture.get_data()
	combImage.blend_rect_mask (sourceImg, maskImg, Rect2(0, 0, $Source.texture.get_width(), $Source.texture.get_height()), Vector2(0, 0))
	
	combTexture.create_from_image(combImage)
	$HeatMap.texture = combTexture

func implementation_2():
	var combImage = Image.new()
	var sourceImg = $Source.texture.get_data()
	var maskImg = $Mask.texture.get_data()
	
	var _scrFormat = sourceImg.get_format()
	var _srcAlphaFormat = sourceImg.detect_alpha()
	
	var _maskFormat = maskImg.get_format()
	var _maskAlphaFormat = maskImg.detect_alpha()
	
	combImage.create($Source.texture.get_width(), $Source.texture.get_height(), false, Image.FORMAT_RGBA8)
	combImage.fill(Color(0, 0, 0, 0))
	
	var combTexture = ImageTexture.new()
		
	combImage.blend_rect_mask (sourceImg, maskImg, Rect2(0, 0, $Source.texture.get_width(), $Source.texture.get_height()), Vector2(0, 0))
	
	combTexture.create_from_image(combImage)
	$HeatMap.texture = combTexture
	
func implementation_3():
	var combImage = Image.new()
	var sourceImg = $Source.texture.get_data()
	var maskImg = $"Object 1/Viewport1".get_texture().get_data() # MAKE SURE THE VIEWPORT HAS TRANSPARENT BACKGROUND SET TO TRUE
	
	var _scrFormat = sourceImg.get_format()
	var _srcAlphaFormat = sourceImg.detect_alpha()
	
	var _maskFormat = maskImg.get_format()
	var _maskAlphaFormat = maskImg.detect_alpha()
	
	combImage.create($Source.texture.get_width(), $Source.texture.get_height(), false, Image.FORMAT_RGBA8)
	combImage.fill(Color(0, 0, 0, 0))
	
	var combTexture = ImageTexture.new()
		
	combImage.blend_rect_mask (sourceImg, maskImg, Rect2(0, 0, $Source.texture.get_width(), $Source.texture.get_height()), Vector2(0, 0))
	
	combTexture.create_from_image(combImage)
	$HeatMap.texture = combTexture

func implementation_4():
	var combImage = Image.new()
	var sourceImg = Image.new()
		
	var viewport1MaskImg = $"Object 1/Viewport1".get_texture().get_data() # MAKE SURE THE VIEWPORT HAS TRANSPARENT BACKGROUND SET TO TRUE
	var viewport2MaskImg = $"Object 2/Viewport2".get_texture().get_data() # MAKE SURE THE VIEWPORT HAS TRANSPARENT BACKGROUND SET TO TRUE
	
	combImage.create(viewport1MaskImg.get_width(), viewport1MaskImg.get_height(), false, Image.FORMAT_RGBA8)
	sourceImg.create(viewport1MaskImg.get_width(), viewport1MaskImg.get_height(), false, Image.FORMAT_RGBA8)
	sourceImg.fill(Color(0, 0, 0, 1))
	
	var _scrFormat = sourceImg.get_format()
	var _srcAlphaFormat = sourceImg.detect_alpha()

	combImage.create($Source.texture.get_width(), $Source.texture.get_height(), false, Image.FORMAT_RGBA8)
	combImage.fill(Color(0, 0, 0, 0))
	
	var combTexture = ImageTexture.new()
		
	combImage.blend_rect_mask (sourceImg, viewport1MaskImg, Rect2(0, 0, $Source.texture.get_width(), $Source.texture.get_height()), Vector2(0, 0))
	combImage.blend_rect_mask (sourceImg, viewport2MaskImg, Rect2(0, 0, $Source.texture.get_width(), $Source.texture.get_height()), Vector2(0, 0))
	
	combTexture.create_from_image(combImage)
	$HeatMap.texture = combTexture
"""
