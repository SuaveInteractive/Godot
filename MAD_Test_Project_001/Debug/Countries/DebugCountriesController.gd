extends Control

signal WindowClosed()
signal SelectedCountryChanged(country)

var Countries = null setget setCountries

func _ready():
	pass

func setCountries(countries) -> void:
	Countries = countries
	_update()
	
func setControllingCountry(controllingCountry) -> void:
	for index in Countries.size():
		if Countries[index] == controllingCountry:
			$"%ControllingCountry".selected = index
	
func _update():
	for country in Countries:
		$"%ControllingCountry".add_item(country.get_name())

func _on_ControllingCountry_item_selected(index):
	emit_signal("SelectedCountryChanged", Countries[index])

func _on_Window_WindowClosed():
	emit_signal("WindowClosed")
