extends Node

var MoveCommandScript = load("res://GameCommand/MoveCommand.gd")
var MoveCommand = MoveCommandScript.new()

var TargetCommandScript = load("res://GameCommand/TargetCommand.gd")
var TargetCommand = TargetCommandScript.new()

var BuildCommandScript = load("res://GameCommand/BuildCommand.gd")
var BuildCommand = BuildCommandScript.new()
