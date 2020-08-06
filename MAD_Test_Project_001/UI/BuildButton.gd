extends Button

func _on_Build_toggled(button_pressed):
	for child in get_children():
		child.visible = button_pressed

func _on_BuildSiloButton_pressed():
	Signals.emit_signal("BuildStructure", {"Building": "Silo"})
