extends "res://GameActions/GameAction.gd"

var ControllingCountry = null
var CountryIntelligence = null
var WorldController : Node = null

var viewIntelPackageUIScene = preload("res://GameActions/ViewIntelPackages/UI/ViewIntelPackagesUI.tscn")
var proposedIntelWidgetScene = preload("res://GameActions/ViewIntelPackages/UI/ProposedIntelWidget.tscn")

var uiSceneInstance : Node = null

func _ready():
	pass

func _init(var parameters):
	ControllingCountry = parameters.ControllingCountry
	WorldController = parameters.WorldController
	
	CountryIntelligence = ControllingCountry.getIntelligenceInterface()
	
	_populateExistingPackages(ControllingCountry.getReceivedIntelligencePackages())
	
func _populateExistingPackages(var intelPackagesArray : Array) -> void:
	for package in intelPackagesArray:
		getUIOverlay().addItem(package.PackageName)
		
func _showPackageIntel(var package : Resource):
	for intel in package.IntelligenceForEntities:
		_addIntelWidget(intel)

func _addIntelWidget(var intel : Node):
	var widgetInstance : Node = proposedIntelWidgetScene.instance()
	
	widgetInstance.connect("AcceptIntel", self, "OnAcceptIntel")
	widgetInstance.connect("RejectIntel", self, "OnRejectIntel")
	
	widgetInstance.setIntel(intel)
	widgetInstance.set_position(Vector2(300, 300))
	add_child(widgetInstance)

func getUIOverlay() -> Object:
	if uiSceneInstance == null:
		uiSceneInstance = viewIntelPackageUIScene.instance()
		uiSceneInstance.connect("PackageSelected", self, "OnPackageSelected")
	return uiSceneInstance
	
"""
	Callbacks
"""
func OnPackageSelected(var packageName):	
	for package in ControllingCountry.getReceivedIntelligencePackages():
		if package.PackageName == packageName:
			_showPackageIntel(package)

func OnAcceptIntel():
	CountryIntelligence.addIntel()
	
func OnRejectIntel():
	pass
