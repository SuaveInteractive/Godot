extends Label

func _ready():
	Signals.connect("CountryControlChange", self, "OnCountryControlChange")
	
func OnCountryControlChange(country, _oldControl, newControl):
	if country.Player:
		self.text = str(newControl)
