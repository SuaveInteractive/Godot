extends Label

func _ready():
	var err = Signals.connect("CountryFinanceChange", self, "OnCountryFinanceChange")
	
func OnCountryFinanceChange(country, oldFinance, newFinance):
	if country.Player:
		self.text = str(newFinance)
