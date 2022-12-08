extends Label

func _ready():
	Signals.connect("CountryFinanceChange", self, "OnCountryFinanceChange")
	
func OnCountryFinanceChange(country, _oldFinance, newFinance):
	#if country.Player:
	#	self.text = str(newFinance)
	pass
