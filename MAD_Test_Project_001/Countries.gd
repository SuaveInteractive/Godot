extends Node

func isPlayerUnit(entity) -> bool:
	for country in get_children():
		if country.Player:
			for countryNode in country.get_children():
				if countryNode == entity:
					return true
	return false

func getCountries() -> Array:
	var countries: Array = []
	for country in get_children():
		countries.push_back(country)
		
	return countries
