extends Control

signal PackageSelected(packageName)

func _ready():
	$DeletePackageButton.disabled = true
	
func addItem(var text : String) -> void:
	$IntelligencePackageList.add_item(text)

func _on_IntelligencePackageList_item_selected(index):
	emit_signal("PackageSelected", $IntelligencePackageList.get_item_text(index))
