extends Node

enum UnitActions {NONE, MoveAction, PatrolAction, TargetAction}
var unitAction = UnitActions.NONE

enum GameActions {NONE, BuildAction}
var gameAction = GameActions.NONE

func _ready():
	pass
