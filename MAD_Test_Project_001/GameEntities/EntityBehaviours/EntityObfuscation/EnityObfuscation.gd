tool
extends Node2D

enum obfuscation_levels {NONE, LOW, MEDIUM, HIGH, TOTAL}

export(obfuscation_levels) var obfuscation_level = obfuscation_levels.NONE

export var obfuscation_none : Texture setget SetNoneTexture
export var obfuscation_low : Texture
export var obfuscation_medium : Texture
export var obfuscation_high : Texture

export var country_colour : Color = Color.fuchsia

func _ready():
	_updateTextures()
	_updateVisibility()
	
	$None.get_material().set_shader_param("colour", country_colour)
	
func _process(_delta):
	if Engine.editor_hint:
		$None.texture = obfuscation_none
		$Low.texture = obfuscation_low
		$Medium.texture = obfuscation_medium
		$High.texture = obfuscation_high
		
func setObfuscationNone() -> void:
	obfuscation_level = obfuscation_levels.NONE
	_updateVisibility()
	
func setObfuscationLow() -> void:
	obfuscation_level = obfuscation_levels.LOW
	_updateVisibility()
	
func setObfuscationMedium() -> void:
	obfuscation_level = obfuscation_levels.MEDIUM
	_updateVisibility()
	
func setObfuscationHigh() -> void:
	obfuscation_level = obfuscation_levels.HIGH
	_updateVisibility()
	
func setObfuscationTotal() -> void:
	obfuscation_level = obfuscation_levels.TOTAL
	_updateVisibility()
	
func SetNoneTexture(var texture : Texture) -> void:
	obfuscation_none = texture
	_updateTextures()
	
func _updateTextures() -> void:
	$None.texture = obfuscation_none
	$Low.texture = obfuscation_low
	$Medium.texture = obfuscation_medium
	$High.texture = obfuscation_high
	
func _updateVisibility() -> void:
	$None.visible = false
	$Low.visible = false
	$Medium.visible = false
	$High.visible = false
	
	match obfuscation_level:
		obfuscation_levels.NONE:
			$None.visible = true
		obfuscation_levels.LOW:
			$Low.visible = true
		obfuscation_levels.MEDIUM:
			$Medium.visible = true
		obfuscation_levels.HIGH:
			$High.visible = true
		obfuscation_levels.TOTAL:
			pass

