extends Node

var targetors : Array 
var worldController : Node

func _ready():
	pass

func _init(parameters):
	targetors = parameters.Targetors
	worldController = parameters.WorldController
	
func _process(_delta):
	pass
	
func _unhandled_input(event : InputEvent) -> void:	
	if not event is InputEventMouseButton:
		return
	if Input.is_action_just_pressed ("Mouse_Select") == true:
		GameCommands.TargetCommand.Target_Position = get_parent().get_parent().get_global_mouse_position() 
		GameCommands.TargetCommand.Units_Targeting = targetors
		GameCommands.TargetCommand.execute()
			
		get_tree().set_input_as_handled()
		Signals.emit_signal("EndGameAction")
