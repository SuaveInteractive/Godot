extends Node

var MoveCommandScript = load("res://GameCommand/MoveCommand.gd")
var MoveCommand = MoveCommandScript.new()

var TargetCommandScript = load("res://GameCommand/TargetCommand.gd")
var TargetCommand = TargetCommandScript.new()

var BuildCommandScript = load("res://GameCommand/BuildCommand.gd")
var BuildCommand = BuildCommandScript.new()

var LaunchStrikeCommandscript = load("res://GameCommand/LaunchStrikeCommand.gd")
var LaunchStrikeCommand = LaunchStrikeCommandscript.new()

var ShareIntelligenceCommandScript = load("res://GameCommand/ShareIntelligenceCommand.gd")
var ShareIntelligence = ShareIntelligenceCommandScript.new()

var CreateIntelligencePackageCommand = load("res://GameCommand/CreateIntelligencePackageCommand.gd")
var CreateIntelligencePackage = CreateIntelligencePackageCommand.new()

func _init():
	add_child(MoveCommand)
	add_child(TargetCommand)
	add_child(BuildCommand)
	add_child(LaunchStrikeCommand)
	add_child(ShareIntelligence)
	add_child(CreateIntelligencePackage)
