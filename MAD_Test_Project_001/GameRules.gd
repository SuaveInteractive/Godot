extends Node

signal CountryWins(country)

func checkRules(countries):
	var activeCountries: int = 0
	var ActiveCountry = null
	
	for country in countries:
		if country.get_control() < 50:
			pass
			#Signals.emit_signal("SetCountryActive", country, false)
		else:
			ActiveCountry = country
			activeCountries = activeCountries + 1
	
	if activeCountries == 1:
		emit_signal("CountryWins", ActiveCountry)
