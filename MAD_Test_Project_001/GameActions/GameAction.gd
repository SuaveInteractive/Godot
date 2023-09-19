extends Node

signal EndGameAction()

func _ready():
	pass
	
# Return a instance of a scene that is the UI for the action or null if there is no overlay.
func getUIOverlay() -> Object:
	return null
	
func EndAction():
	emit_signal("EndGameAction")

