extends Control

export(String) var WorldPositionString = "World Pos: %s"
export(String) var ScreenPositionString = "Screen Pos: %s"

func _ready():
	pass
	
func _process(_delta):
	set_position(get_viewport().get_mouse_position())
	
func _input(event):
	if event is InputEventMouseMotion:
		$"VBoxContainer/Screen Position".text = str(ScreenPositionString % get_viewport().get_mouse_position())

func setWorldPosition(var worldPos : Vector2) -> void:
	$"VBoxContainer/World Position".text = str(WorldPositionString % worldPos)
