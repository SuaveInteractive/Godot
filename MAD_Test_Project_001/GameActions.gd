extends Node

var GameActionScript = preload("res://GameActions/BuildAction.gd")

var CurrentAction = null

func _ready():
	Signals.connect("EndGameAction", self, "OnEndGameAction")
	
func startAction(actionInfo) -> void:
	CurrentAction = GameActionScript.new(actionInfo)
	add_child(CurrentAction, true)
	
func endAction() -> void:
	remove_child(CurrentAction)
	CurrentAction = null
	
func OnEndGameAction() -> void:
	endAction()
