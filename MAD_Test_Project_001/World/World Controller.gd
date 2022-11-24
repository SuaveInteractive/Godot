extends Node

var WorldModel : Node = null

func _ready():
	pass
	
func loadWorldScene(worldInformationPath : String) -> void:
	$"World Model".setWorldModel(load(worldInformationPath))
	
func getCountries() -> Array:
	var countries: Array = []
	for country in WorldModel.WorldInformation.Countries():
		countries.push_back(country)
		
	return countries

func isPlayerUnit(entity) -> bool:
	for country in WorldModel.WorldInformation.Countries():
		if country.Player:
			for countryNode in country.get_children():
				if countryNode == entity:
					return true
	return false
