extends Control

signal AcceptIntel()
signal RejectIntel()

var countryColourShaderParam : Color = Color.fuchsia

func _ready():
	$WidgetHBox/IntelIcon.get_material().set_shader_param("replacementColour", countryColourShaderParam)

func setIntel(var _intel):
	pass
	
"""
	Callbacks
"""
func _on_AcceptButton_pressed():
	emit_signal("AcceptIntel")

func _on_RejectButton_pressed():
	emit_signal("RejectIntel")
