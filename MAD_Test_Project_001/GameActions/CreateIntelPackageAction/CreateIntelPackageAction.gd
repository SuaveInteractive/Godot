extends "res://GameActions/GameAction.gd"

var ControllingCountry = null
var CountryIntelligence = null

var intelWidgetScene = preload("res://GameActions/CreateIntelPackageAction/IntelligenceWidget.tscn")

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
	
