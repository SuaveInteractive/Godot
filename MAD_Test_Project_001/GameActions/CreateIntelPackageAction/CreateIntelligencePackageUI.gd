extends Control

signal CreatePacked(packageName)

func _ready():
	pass

func addItem(var text : String) -> void:
	$IntelligencePackageList.add_item(text)

func _on_CreatePackageButton_pressed():
	$EnterPackageNameDialog.popup_centered()

func _on_EnterPackageNameDialog_confirmed():
	emit_signal("CreatePacked", $EnterPackageNameDialog/NameTextField.text)
