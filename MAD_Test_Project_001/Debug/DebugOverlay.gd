extends CanvasLayer

# http://kidscancode.org/godot_recipes/ui/debug_overlay/
# var DebugShowCountryBoardersScript = load("res://Debug/DebugShowCountryBoarders.gd")


var RootDebugControls : Control = null

func _ready():
	self.layer = 99
		
	RootDebugControls = Control.new()
	RootDebugControls.name = "DebugControls"
	RootDebugControls.visible = false
	add_child(RootDebugControls)
	
	""" Set the Style of the Controls """
	var t = load("res://Debug/DebugTheme.theme") 
	RootDebugControls.set_theme(t)
	
	#var checkbutton = CheckButton.new()
	#checkbutton.text = "Show Boarders"	
	#Root.add_child(checkbutton)

func _process(_delta):
	if Input.is_action_just_pressed("DebugMenuToggle"):
		RootDebugControls.visible = !RootDebugControls.visible

func addDebugControl(control):
	RootDebugControls.add_child(control.getGUIControl())
	add_child(control)

""" Add and remove Properties from the debug Menu """
func add_property(object, property, display):
	pass

func remove_property(object, property):
	pass
