extends Sprite

var currentAction

func _ready():
	hide()
	
func _process(_delta):
	position = get_viewport().get_mouse_position()

func SetCurrentAction(action):
	currentAction = action
	
	if currentAction > 0:
		show()
	else:
		hide()
