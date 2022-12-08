extends Node
class_name Country

var CountryColour : Color = Color(255) setget , get_colour
var Control : int = 0 setget set_control, get_control
var Finance : int = 0 setget set_finance, get_finance

func _init(name, color):
	self.set_name(name)
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
	
func get_colour() -> Color:
	return CountryColour
