extends Control

# https://www.youtube.com/watch?v=L5QjuFe5Gys

signal WindowClosed()

var AIList = null

func _ready():
	$AIStateWindow/AIStateInfoContainer/CurrentAction.visible = false
	
	
	$AIStateWindow/AIStateInfoContainer.connect("AIStateInfoChanged", self, "OnAIStateInfoChanged")
	
func _init():
	pass
	
func SetAIs(aiList):
	AIList = aiList
	for ai in AIList:
		$AIStateWindow/AIStateInfoContainer/OptionButton.add_item(ai.get_name())
	$AIStateWindow/AIStateInfoContainer.SetAIInformation(AIList[0])
		
func OnAIStateInfoChanged(index):
	$AIStateWindow/AIStateInfoContainer.SetAIInformation(AIList[index])

func _on_AIStateWindow_WindowClosed():
	emit_signal("WindowClosed")
