extends Node

func _ready():
	set_name("AI Controller")

func addAIOpponent(aiOppoenent):
	add_child(aiOppoenent)
