extends Control

signal CreatePacked(packageName)
signal PackageSelected(packageName)

func _ready():
	$EnterPackageNameDialog.get_ok().disabled = true
	
func addItem(var text : String) -> void:
	$IntelligencePackageList.add_item(text)

func _on_CreatePackageButton_pressed():
	$EnterPackageNameDialog.popup_centered()

func _on_EnterPackageNameDialog_confirmed():
	emit_signal("CreatePacked", $EnterPackageNameDialog/NameTextField.text)

func _on_NameTextField_text_changed():
	if $EnterPackageNameDialog/NameTextField.text.empty():
		$EnterPackageNameDialog.get_ok().disabled = true
	else:
		$EnterPackageNameDialog.get_ok().disabled = false

func _on_EnterPackageNameDialog_about_to_show():
	$EnterPackageNameDialog/NameTextField.text = ""	

func _on_IntelligencePackageList_item_selected(index):
	emit_signal("PackageSelected", $IntelligencePackageList.get_item_text(index))