extends Label

func _ready():
	var err = Signals.connect("CountryControlChange", self, "OnCountryControlChange")
	
func OnCountryControlChange(country, oldControl, newControl):
	if country.Player:
		self.text = str(newControl)
