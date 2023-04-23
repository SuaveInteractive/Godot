tool
extends Node2D

export var obfuscation_none : Texture 
export var obfuscation_low : Texture
export var obfuscation_medium : Texture
export var obfuscation_high : Texture

export var country_colour : Color = Color.fuchsia

func _ready():
	$None.texture = obfuscation_none
	$Low.texture = obfuscation_low
	$Medium.texture = obfuscation_medium
	$High.texture = obfuscation_high
	
	$None.get_material().set_shader_param("colour", country_colour)
	
func _process(delta):
	if Engine.editor_hint:
		$None.texture = obfuscation_none
		$Low.texture = obfuscation_low
		$Medium.texture = obfuscation_medium
		$High.texture = obfuscation_high
	

