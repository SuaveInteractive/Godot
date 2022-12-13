extends Node

func _ready():
	pass
	
func loadWorldScene(worldInformationPath : String) -> void:
	$"World Model".setWorldModel(load(worldInformationPath))
	
func getCountries() -> Array:
	return $"World Model".getCountries()
	
func getSelectedEntities() -> Array:
	return $"World Model".getSelectedEntities()
	
func setSelectedEntities(selectedEntities : Array) -> void:
	$"World Model".setSelectedEntities(selectedEntities)

func isPlayerUnit(entity) -> bool:
	for country in $"World Model".getCountries():
		if country.Player:
			for countryNode in country.get_children():
				if countryNode == entity:
					return true
	return false

func _unhandled_input(event : InputEvent) -> void:	
	if not event is InputEventMouseButton:
		return
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		$"World Model".setSelectedEntities([])

func _on_World_View_UnitSelected(unit):
	var selectedEntities : Array = []
	if Input.is_action_pressed("MultiSelect"):
		selectedEntities = $"World Model".getSelectedEntities()
	selectedEntities.append(unit)	
	$"World Model".setSelectedEntities(selectedEntities)
