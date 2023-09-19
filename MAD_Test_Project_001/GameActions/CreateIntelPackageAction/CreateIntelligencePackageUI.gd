extends Control

signal CreatePacked

func _ready():
	pass

func addItem(var text : String) -> void:
	$IntelligencePackageList.add_item(text)

func _on_CreatePackageButton_pressed():
	emit_signal("CreatePacked")
