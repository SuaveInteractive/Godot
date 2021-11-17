extends CanvasLayer

# http://kidscancode.org/godot_recipes/ui/debug_overlay/

var Root : Control = null

func _ready():
	self.layer = 99
	
	Root = Control.new()
	Root.name = "DebugRoot"
	Root.visible = false
	add_child(Root)
	
	var checkbutton = CheckButton.new()
	checkbutton.text = "Show Boarders"	
	Root.add_child(checkbutton)

func _process(_delta):
	if Input.is_action_just_pressed("DebugMenuToggle"):
		Root.visible = !Root.visible

func add_node(node):
	Root.add_child(node)

""" Add and remove Properties from the debug Menu """
func add_property(object, property, display):
	pass

func remove_property(object, property):
	pass
