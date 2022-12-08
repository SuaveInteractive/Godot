extends Node

func checkRules(countries):
	var activeCountries: int = 0
	var ActiveCountry = null
	
	for country in countries:
		if country.get_control() < 50:
			Signals.emit_signal("SetCountryActive", country, false)
		else:
			ActiveCountry = country
			activeCountries = activeCountries + 1
	
	if activeCountries == 1:
		Signals.emit_signal("CountryWins", ActiveCountry)
