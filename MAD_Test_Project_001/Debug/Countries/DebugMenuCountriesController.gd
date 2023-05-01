extends Node2D 

var debugCountryController = load("res://Debug/Countries/DebugCountriesController.tscn")

var checkbutton : CheckButton = null

var Countries = null
var ControllingCountry = null
var ChangeCountryFunc = null

func _init(var countries, var changeCountryFunc):
	self.name = "Debug Show Country Controller"
	
	Countries = countries
	ChangeCountryFunc = changeCountryFunc
		
func _ready():
	pass

func getGUIControl():
	checkbutton = CheckButton.new()
	checkbutton.name = "Show Country Controller"
	checkbutton.text = "Show Country Controller"	
	
	var _ret = checkbutton.connect("toggled", self, "OnButtonToggle")
	
	return checkbutton;
	
func OnButtonToggle(toggle):
	if toggle:
		pass
		var debugCountryControllerInstance = debugCountryController.instance()
	
		debugCountryControllerInstance.setCountries(Countries)
		debugCountryControllerInstance.setControllingCountry(ControllingCountry)
		add_child(debugCountryControllerInstance)

		debugCountryControllerInstance.connect("SelectedCountryChanged", self, "OnSelectedCountryChanged")
		debugCountryControllerInstance.connect("WindowClosed", self, "OnWindowClosed")
	elif get_child(0):
		get_child(0).queue_free()

func OnWindowClosed():
	checkbutton.pressed = false
	
func OnSelectedCountryChanged(country):
	ChangeCountryFunc.call_func(country)
	
func OnControllingCountryChanged(country):
	ControllingCountry = country
