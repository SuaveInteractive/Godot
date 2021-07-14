extends Node
class_name Country

var CountryColour : Color = Color(255)
var Player : bool  = false
var Control : int = 0 setget set_control

func _init(_name, _player, r, g, b, a):
	self.set_name(_name)
	Player = _player
	CountryColour = Color(r, g, b, a)
	set_control(85)
	
	self.add_to_group('Persistent')
	
func _process(_delta):
	pass
	
func addCity(_city) -> void:
	_city.setCountry(self)
	add_child(_city)

func addUnit(_unit) -> void:
	_unit.setCountry(self)
	#if Player:
	#	_unit.connect("clicked", get_parent().get_parent(), "OnUnitSelected")
	add_child(_unit)
	
func set_control(control: int) -> void:
	if Control != control:
		Signals.emit_signal("CountryControlChange", self, Control, control)
		Control = control
	
func save():	
	var save_dict = {
		"scriptPath": get_script().get_path(),
		"parent" : get_parent().get_path(),
		"args" : [self.get_name(), Player, CountryColour.r, CountryColour.g, CountryColour.b, CountryColour.a],
	}	
	return save_dict

func load(_dic):
	pass
	
func addChildMethod(node):
	node.setCountry(self)
	#if Player:
	#	node.connect("clicked", get_parent(), "OnUnitSelected")
	add_child(node)
	
