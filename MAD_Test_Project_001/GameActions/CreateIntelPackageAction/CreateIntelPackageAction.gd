extends "res://GameActions/GameAction.gd"

var ControllingCountry = null
var CountryIntelligence = null

var intelWidgetScene = preload("res://GameActions/CreateIntelPackageAction/IntelligenceWidget.tscn")
var createIntelPackageUIScene = preload("res://GameActions/CreateIntelPackageAction/CreateIntelligencePackageUI.tscn")

var uiSceneInstance : Node = null

func _ready():
	pass

func _init(var parameters):
	ControllingCountry = parameters.ControllingCountry
	CountryIntelligence = ControllingCountry.getIntelligenceInterface()
	
	_setupIntelligence(ControllingCountry, CountryIntelligence.getKnownIntelligence())

func _setupIntelligence(var country : Node, var intelligence : Dictionary):
	for entity in intelligence:
		if not country.isOwned(entity):
			var intelLevel = intelligence[entity]
			_addIntelWidget(entity, intelLevel)
			
func _addIntelWidget(var entity : Node, var intelLevel : int):
	var widgetInstance : Node = intelWidgetScene.instance()
	widgetInstance.setFocus(entity)
	add_child(widgetInstance)
	
func getUIOverlay() -> Object:
	if uiSceneInstance == null:
		uiSceneInstance = createIntelPackageUIScene.instance()
		uiSceneInstance.connect("CreatePacked", self, "OnCreatePacked")
	return uiSceneInstance
	
"""
	Callbacks
"""
func OnCreatePacked():
	var intelPackage = IntelligencePackageResourceDef.new()
	
	for childWidget in get_children():
		if childWidget.isSelected():
			var nodeForIntel : Node = childWidget.getFocus()
			
			var unitIntel = UnitIntelligenceResourceDef.new()
			unitIntel.EntityNodePath = nodeForIntel.get_path()
			
			intelPackage.IntelligenceForEntities.push_back(unitIntel)
	
	if intelPackage.IntelligenceForEntities.size() > 0:
		ControllingCountry.addIntelPackage(intelPackage)
		getUIOverlay().addItem("TESTER")
			
