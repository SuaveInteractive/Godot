extends Node

signal EndGameAction()

func _ready():
	pass

func EndAction():
	emit_signal("EndGameAction")
