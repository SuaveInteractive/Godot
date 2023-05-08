extends Button

signal UIBuildStructure(buildInfo)

func _on_Build_toggled(button_pressed):
	$BuildButtonVBoxContainer.visible = button_pressed

func _on_BuildSiloButton_pressed():
	emit_signal("UIBuildStructure", {"ActionName": "BuildAction", "BuildingName": "Silo", "Texture": "res://GameEntities/Structure/Silo/FullHealth.png", "Scale": Vector2(0.75, 0.75)})


func _on_BuildRadarButton_pressed():
	emit_signal("UIBuildStructure", {"ActionName": "BuildAction", "BuildingName": "Radar", "Texture": "res://GameEntities/Structure/Radar/Construction.png", "Scale": Vector2(0.12, 0.12)})
