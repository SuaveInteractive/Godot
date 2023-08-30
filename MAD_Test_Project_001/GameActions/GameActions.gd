extends Node

var ActionDic : Dictionary = {}

var CurrentAction = null

func _ready():
	ActionDic["BuildAction"] = load("res://GameActions/BuildAction.gd")
	ActionDic["MoveUnitAction"] = load("res://GameActions/MoveUnitAction.gd")
	ActionDic["TargetAction"] = load("res://GameActions/TargetAction.gd")
	ActionDic["LaunchStrikeAction"] = load("res://GameActions/LaunchStrikeAction.gd")
	ActionDic["CreateIntelPackageAction"] = load("res://GameActions/CreateIntelPackageAction/CreateIntelPackageAction.gd")
	
func startAction(actionInfo) -> void:
	if ActionDic.has(actionInfo.ActionName):
		CurrentAction = ActionDic[actionInfo.ActionName].new(actionInfo)
		add_child(CurrentAction, true)
		
		CurrentAction.connect("EndGameAction", self, "OnEndGameAction")
	else:
		push_error("No action named: %s" % actionInfo.ActionName)
	
func endAction() -> void:
	remove_child(CurrentAction)
	CurrentAction = null
	
func OnEndGameAction() -> void:
	endAction()
