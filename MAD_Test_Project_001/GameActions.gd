extends Node

var ActionDic : Dictionary = {}

var CurrentAction = null

func _ready():
	ActionDic["BuildAction"] = preload("res://GameActions/BuildAction.gd")
	ActionDic["MoveUnitAction"] = preload("res://GameActions/MoveUnitAction.gd")
	ActionDic["Target"] = preload("res://GameActions/TargetAction.gd")

	Signals.connect("EndGameAction", self, "OnEndGameAction")
	
func startAction(actionInfo) -> void:
	if ActionDic.has(actionInfo.ActionName):
		CurrentAction = ActionDic[actionInfo.ActionName].new(actionInfo)
		add_child(CurrentAction, true)
	else:
		push_error("No action named: %s" % actionInfo.ActionName)
	
func endAction() -> void:
	remove_child(CurrentAction)
	CurrentAction = null
	
func OnEndGameAction() -> void:
	endAction()
