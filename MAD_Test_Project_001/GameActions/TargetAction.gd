extends Node

var targetorIDs : Array 
var worldController : Node

func _ready():
	pass

func _init(parameters):
	targetorIDs = parameters.TargetorIDs
	worldController = parameters.WorldController
	
func _process(_delta):
	pass
	
func _unhandled_input(event : InputEvent) -> void:	
	if not event is InputEventMouseButton:
		return
	if Input.is_action_just_pressed ("Mouse_Select") == true:
		GameCommands.TargetCommand.Target_Position = get_parent().get_parent().get_global_mouse_position() 
		GameCommands.TargetCommand.WorldController = worldController
		GameCommands.TargetCommand.TargetorIDs = targetorIDs
		GameCommands.TargetCommand.execute()
			
		get_tree().set_input_as_handled()
		Signals.emit_signal("EndGameAction")
