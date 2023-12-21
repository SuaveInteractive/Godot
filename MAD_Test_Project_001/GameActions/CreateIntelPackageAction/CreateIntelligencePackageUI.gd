extends Control

signal CreatePacked(packageName)
signal PackageSelected(packageName)
signal PackageSend(packageName, sendToCountry)

signal IntelAdded(screenPosition)

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
	$SharePackageButton.disabled = false
	emit_signal("PackageSelected", $IntelligencePackageList.get_item_text(index))

func _on_SharePackageButton_pressed():
	var selection : PoolIntArray = $IntelligencePackageList.get_selected_items()
	var selectedNames : Array = []
	for selected in selection:
		var name = $IntelligencePackageList.get_item_text(selected)
		selectedNames.append(name)
	
	if selectedNames.size() > 0:
		emit_signal("PackageSend", selectedNames[0], "Country_2")

func _on_ItemList_item_selected(index):
	pass # Replace with function body.

func _on_DragController_IntelAdded(screenPos, type):
	emit_signal("IntelAdded", screenPos)
	
#https://duckduckgo.com/?q=godot+how+to+drag+items+inventory&t=braveed&iax=videos&ia=videos&iai=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DdZYlwmBCziM

