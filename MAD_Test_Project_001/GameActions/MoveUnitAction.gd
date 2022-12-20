extends Node

func _ready():
	pass

func _process(_delta):
	pass
	
func _unhandled_input(event : InputEvent) -> void:	
	if not event is InputEventMouseButton:
		return
		
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		#GameCommands.BuildCommand.Position_Build = MouseIcon.position
		#GameCommands.BuildCommand.Build_Info = Params
		#GameCommands.BuildCommand.execute()
		#get_tree().set_input_as_handled()
		
		Signals.emit_signal("EndGameAction")
