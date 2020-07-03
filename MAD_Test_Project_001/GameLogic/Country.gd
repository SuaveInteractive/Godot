extends Node

var CountryColour : Color = Color(255)
var Player : bool  = false

func _init(_name, _player, _colour):
	self.set_name(_name)
	Player = _player
	CountryColour = _colour
	
func _process(_delta):
	pass
	
func addCity(_city) -> void:
	_city.setCountry(self)
	add_child(_city)

func addUnit(_unit) -> void:
	_unit.setCountry(self)
	if Player:
		_unit.connect("clicked", get_parent(), "OnUnitSelected")
	add_child(_unit)
