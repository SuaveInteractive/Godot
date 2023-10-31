extends Node

var ActionDic : Dictionary = {}

var CurrentAction = null

signal ShowUIOverlay(uiOverlayInstance)
signal HideUIOverlay(uiOverlayInstance)

func _ready():
	ActionDic["BuildAction"] = load("res://GameActions/BuildAction.gd")
	ActionDic["MoveUnitAction"] = load("res://GameActions/MoveUnitAction.gd")
	ActionDic["TargetAction"] = load("res://GameActions/TargetAction.gd")
	ActionDic["LaunchStrikeAction"] = load("res://GameActions/LaunchStrikeAction.gd")
	ActionDic["CreateIntelPackageAction"] = load("res://GameActions/CreateIntelPackageAction/CreateIntelPackageAction.gd")
	ActionDic["ViewIntelPackageAction"] = load("res://GameActions/ViewIntelPackages/ViewIntelPackageAction.gd")
	
func startAction(actionInfo) -> void:
	if ActionDic.has(actionInfo.ActionName):
		CurrentAction = ActionDic[actionInfo.ActionName].new(actionInfo)
		add_child(CurrentAction, true)
		
		var uiOverlayInstance = CurrentAction.getUIOverlay()
		if uiOverlayInstance != null:
			emit_signal("ShowUIOverlay", uiOverlayInstance)
		
		CurrentAction.connect("EndGameAction", self, "OnEndGameAction")
	else:
		push_error("No action named: %s" % actionInfo.ActionName)
	
func endAction() -> void:
	var uiOverlayInstance = CurrentAction.getUIOverlay()
	if uiOverlayInstance != null:
		emit_signal("HideUIOverlay", uiOverlayInstance)
	
	remove_child(CurrentAction)
	CurrentAction = null
	
func OnEndGameAction() -> void:
	endAction()
