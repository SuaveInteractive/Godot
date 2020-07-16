extends Node

var Countries : Array = [] 

func addCountry(country):
	Countries.push_back(country) 
	
func getCountries() -> Array:
	return Countries

