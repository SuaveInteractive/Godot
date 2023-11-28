extends Control

signal AcceptIntel(IntelPosition)
signal RejectIntel()

var countryColourShaderParam : Color = Color.fuchsia

func _ready():
	$WidgetHBox/IntelIcon.get_material().set_shader_param("replacementColour", countryColourShaderParam)

func setIntel(var intel):
	var size : Vector2 = $WidgetHBox/IntelIcon.get_size()
	var offsetPos : Vector2 = Vector2(intel.position.x - (size.x / 2), intel.position.y - (size.y / 2))
	set_position(offsetPos)
	
"""
	Callbacks
"""
func _on_AcceptButton_pressed():
	var size : Vector2 = $WidgetHBox/IntelIcon.get_size()
	var offsetPos : Vector2 = Vector2(get_global_position().x + (size.x / 2), get_global_position().y + (size.y / 2))
	
	emit_signal("AcceptIntel", offsetPos)

func _on_RejectButton_pressed():
	emit_signal("RejectIntel")
