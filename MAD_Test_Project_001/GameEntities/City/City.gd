extends Area2D

class_name City

signal PopulationChanged(population)

var maxPopulation = 100 setget setPopulation, getPopulation
var population = 100 setget setPopulation, getPopulation

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
	$CitySprite.get_material().set_shader_param("colour", _country.CountryColour)

func save():
	var save_dict = {
		"filename" : get_filename(),
		"name" : name,
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
	}
	return save_dict

func load(_dic):
	position.x = _dic["pos_x"]
	position.y = _dic["pos_y"]
