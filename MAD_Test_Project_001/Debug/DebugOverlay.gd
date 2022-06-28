extends CanvasLayer

# http://kidscancode.org/godot_recipes/ui/debug_overlay/

var RootDebugControls : Control = null
var VBox : VBoxContainer = null

func _ready():
	self.layer = 99 # To ensure it is drawn on top of everything else.
	
	var testViewport = get_viewport()
		
	RootDebugControls = Control.new()
	RootDebugControls.name = "DebugControls"
	RootDebugControls.visible = false
	add_child(RootDebugControls)
	
	VBox = VBoxContainer.new()
	VBox.name = "Container"
	RootDebugControls.add_child(VBox)
	
	""" Set the Style of the Controls """
	var t = load("res://Debug/DebugTheme.theme") 
	RootDebugControls.set_theme(t)
	
func _process(_delta):
	if Input.is_action_just_pressed("DebugMenuToggle"):
		RootDebugControls.visible = !RootDebugControls.visible

func addDebugControl(control):
	VBox.add_child(control.getGUIControl())
	get_viewport().add_child(control)

""" Add and remove Properties from the debug Menu """
func add_property(object, property, display):
	pass

func remove_property(object, property):
	pass
