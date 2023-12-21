extends Node

var worldScreenPositionUIScene = load("res://Debug/WorldScreenPosition/WorldScreenPosition.tscn")
var worldScreenPositionUIInstance = null

var canvasObject = null

var checkbutton : CheckButton = null

func _init(canvasObj):
	canvasObject = canvasObj

func _ready():
	pass
	
func _process(_delta):
	if worldScreenPositionUIInstance:
		worldScreenPositionUIInstance.setWorldPosition(canvasObject.get_local_mouse_position())

func getGUIControl():
	checkbutton = CheckButton.new()
	checkbutton.name = "Show World and Screen Position"
	checkbutton.text = "Show World and Screen Position"	
	
	var _ret = checkbutton.connect("toggled", self, "OnButtonToggle")
	
	return checkbutton;

func OnButtonToggle(toggle):
	if toggle:
		worldScreenPositionUIInstance = worldScreenPositionUIScene.instance()
		add_child(worldScreenPositionUIInstance)
	elif get_child(0):
		get_child(0).queue_free()
		worldScreenPositionUIInstance = null

# https://docs.godotengine.org/en/3.5/tutorials/2d/2d_transforms.html
