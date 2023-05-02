extends Button

signal UIBuildStructure(buildInfo)

func _on_Build_toggled(button_pressed):
	for child in get_children():
		child.visible = button_pressed

func _on_BuildSiloButton_pressed():
	emit_signal("UIBuildStructure", {"ActionName": "BuildAction", "BuildingName": "Silo", "Texture": "res://GameEntities/Silo/silo.png", "Scale": Vector2(0.75, 0.75)})
