extends Node

var WorldModel : Node = null

func _ready():
	WorldModel = $"World Model"
	
func loadWorld(worldInformationPath : String) -> void:
	WorldModel.setWorldModel(load(worldInformationPath))
	
func getWorldSize() -> Vector2:
	return WorldModel.getWorldSize()
	
func getCountries() -> Array:
	return WorldModel.getCountries()
	
func getSelectedUnits() -> Array:
	return WorldModel.getSelectedUnits()
		
func setSelectedEntities(selectedEntities : Array) -> void:
	WorldModel.setSelectedEntities(selectedEntities)
	
func getNavPolygon() -> Navigation2D:
	return WorldModel.getNavPolygon()

func getCountryBuildArea():
	return getCountries()[0].Boarder
	
func addBuilding(type, position, country):
	WorldModel.addBuilding(type, position, country)	
	
func addTarget(selectedUnit, targetPos):
	WorldModel.addTarget(selectedUnit, targetPos)
	
func getTargetsForCountry(country) -> Array:
	return WorldModel.getTargetsForCountry(country)
	
func getPosition(node2D : Node2D) -> Vector2:
	return WorldModel.getPosition(node2D)
	
func launchMissile(country, from, target):
	country.addMissile(from, target)

func _unhandled_input(event : InputEvent) -> void:	
	if not event is InputEventMouseButton:
		return
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		WorldModel.setSelectedEntities([])

func _on_World_View_UnitSelected(unit):
	var selectedEntities : Array = []
	if Input.is_action_pressed("MultiSelect"):
		selectedEntities = WorldModel.getSelectedEntities()
	selectedEntities.append(unit)	
	WorldModel.setSelectedEntities(selectedEntities)
