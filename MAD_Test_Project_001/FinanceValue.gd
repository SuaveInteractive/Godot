extends Label
	
func OnCountryFinanceChange(_oldFinance, newFinance):
	self.text = str(newFinance)
