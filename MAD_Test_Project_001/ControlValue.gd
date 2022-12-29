extends Label
	
func OnCountryControlChange(_oldControl, newControl):
	self.text = str(newControl)
