extends "res://GameActions/GameAction.gd"

var selectedUnits = null
var worldController : Node = null

func _init(parameters = null):
	selectedUnits = parameters.SelectedUnits
	worldController = parameters.WorldController
	
func _ready():
	pass

func _process(_delta):
	pass
	
func _unhandled_input(event : InputEvent) -> void:	
	if not event is InputEventMouseButton:
		return
		
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		GameCommands.MoveCommand.MapName = "WaterMapRID"
		GameCommands.MoveCommand.Position_To = get_parent().get_parent().get_global_mouse_position() 
		GameCommands.MoveCommand.Selected_Units = selectedUnits			
		GameCommands.MoveCommand.execute()
		
		get_tree().set_input_as_handled()
		
		EndAction()
