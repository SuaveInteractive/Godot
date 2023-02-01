extends VBoxContainer

export(Array, Resource) var Countries

signal AIStateInfoChanged(index)

func _ready():
	pass

func SetAIInformation(aiInfo):
	# Display current Plans
	if aiInfo.currentPlans.size() > 0:
		$CurrentAction.text = aiInfo.currentPlans[0]

func _on_OptionButton_item_selected(index):
	emit_signal("AIStateInfoChanged", index)
	
