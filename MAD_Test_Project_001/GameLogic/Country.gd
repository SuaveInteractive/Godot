extends Node
class_name Country

var CountryColour : Color = Color(255)
var Player : bool  = false setget , get_player
var Control : int = 0 setget set_control, get_control
var Finance : int = 0 setget set_finance, get_finance
var Active : bool  = true setget , get_active

func _init(_name, _player, color):
	self.set_name(_name)
	Player = _player
	CountryColour = color
	set_control(85)
	set_finance(1000000)
	
	Signals.connect("SetCountryActive", self, "OnSetCountryActive")
	
	self.add_to_group('Persistent')
	
func _process(_delta):
	set_control(calculateControl())
	
func calculateControl() -> int:
	var control: int = 85
	
	for child in get_children():
		if child.is_class("City"):
			var cityPop = child.getPopulation()
			var per: float  = (float(cityPop)/100)
			control = int(control * per)
		
	return control
	
func addCity(_city) -> void:
	_city.setCountry(self)
	add_child(_city)

func addUnit(_unit) -> void:
	_unit.setCountry(self)
	add_child(_unit)
	
func OnSetCountryActive(country, active) -> void:
	if self == country:
		Active = active
"""
	Getters and Setters
"""
func get_player() -> bool:
	return Player
	
func set_control(control: int) -> void:
	if Control != control:
		Signals.emit_signal("CountryControlChange", self, Control, control)
		Control = control
		
func get_control() -> int:
	return Control
	
func set_finance(finance: int) -> void:
	if Finance != finance:
		Signals.emit_signal("CountryFinanceChange", self, Finance, finance)
		Finance = finance
	
func get_finance() -> int:
	return Finance
	
func reduceFinance(var reduction: int) -> void:
	var newFinance = Finance - reduction
	Signals.emit_signal("CountryFinanceChange", self, Finance, newFinance)
	Finance = newFinance
		
func get_active() -> bool:
	return Active

"""
	Serialization
"""	
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
	add_child(node)
	
