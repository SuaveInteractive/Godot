extends Area2D

class_name City

signal PopulationChanged(population)

var maxPopulation = 100 setget setPopulation, getPopulation
var population = 100 setget setPopulation, getPopulation

var CountryBelongsTo : String

func _ready():
	$DamagedCity.visible = false
	# Duplicate the shader material so that it's uniforms can be set per object
	$CitySprite.set_material($CitySprite.get_material().duplicate())

"""
 For RTTI
"""
func get_class() -> String: 
	return "City"
	
func is_class(name: String) -> bool:
   return .is_class(name) or (get_class() == name)

func setPopulation(_value):
	if population != _value:
		population = _value
		
		if population < maxPopulation / 2:
			$CitySprite.visible = false
			$DamagedCity.visible = true
		
		emit_signal("PopulationChanged", population)
	
func getPopulation():
	return population
	
func setCountry(_country):
	CountryBelongsTo = _country
