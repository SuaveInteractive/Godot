extends Node

var WorldModel : Node = null

func _ready():
	pass
	
func loadWorldScene(worldInformationPath : String) -> void:
	$"World Model".setWorldModel(load(worldInformationPath))
	
func getCountries() -> Array:
	var countries: Array = []
	for country in WorldModel.WorldInformation.Countries():
		countries.push_back(country)
		
	return countries

func isPlayerUnit(entity) -> bool:
	for country in WorldModel.WorldInformation.Countries():
		if country.Player:
			for countryNode in country.get_children():
				if countryNode == entity:
					return true
	return false

func _unhandled_input(event : InputEvent) -> void:	
	if not event is InputEventMouseButton:
		return
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		print ("World Controller - _unhandled_input")
		$"World Model".setSelectedEntities([])

func _on_World_View_UnitSelected(unit):
	var selectedEntities : Array = []
	if Input.is_action_pressed("MultiSelect"):
		selectedEntities = $"World Model".getSelectedEntities()
	selectedEntities.append(unit)	
	$"World Model".setSelectedEntities(selectedEntities)
