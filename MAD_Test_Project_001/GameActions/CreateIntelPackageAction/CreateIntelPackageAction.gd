extends "res://GameActions/GameAction.gd"

var ControllingCountry = null
var CountryIntelligence = null
var WorldController : Node = null
var CameraToUse : Camera2D = null

var intelWidgetScene = preload("res://GameActions/CreateIntelPackageAction/IntelligenceWidget.tscn")
var createIntelPackageUIScene = preload("res://GameActions/CreateIntelPackageAction/CreateIntelligencePackageUI.tscn")

var uiSceneInstance : Node = null

func _ready():
	pass

func _init(var parameters):
	ControllingCountry = parameters.ControllingCountry
	WorldController = parameters.WorldController
	CameraToUse = parameters.Camera
	
	CountryIntelligence = ControllingCountry.getIntelligenceInterface()
	
	_setupIntelligence(ControllingCountry, CountryIntelligence.getKnownTrackableIntelligence())
	
	_populateExistingPackages(ControllingCountry.getIntelligencePackages())
	
func _setupIntelligence(var country : Node, var intelligence : Dictionary):
	for entity in intelligence:
		if not country.isOwned(entity):
			var intelLevel = intelligence[entity]
			_addIntelWidget(entity, intelLevel)
			
func _addIntelWidget(var entity : Node, var _intelLevel : int):
	var widgetInstance : Node = intelWidgetScene.instance()
	widgetInstance.setFocus(entity)
	add_child(widgetInstance)
	
func _populateExistingPackages(var intelPackagesArray : Array) -> void:
	for package in intelPackagesArray:
		getUIOverlay().addItem(package.PackageName)
	
func getUIOverlay() -> Object:
	if uiSceneInstance == null:
		uiSceneInstance = createIntelPackageUIScene.instance()
		uiSceneInstance.connect("CreatePacked", self, "OnCreatePacked")
		uiSceneInstance.connect("PackageSelected", self, "OnPackageSelected")
		uiSceneInstance.connect("PackageSend", self, "OnSendPackage")
		uiSceneInstance.connect("IntelAdded", self, "OnIntelAdded")
	return uiSceneInstance
	
"""
	Callbacks
"""
func OnCreatePacked(var packageName):	
	var collectedIntel : Array = []
	
	for childWidget in get_children():
		if childWidget.isSelected():
			var nodeForIntel : Node = childWidget.getFocus()
			collectedIntel.push_back(nodeForIntel)
			
	if collectedIntel.size() > 0:
		getUIOverlay().addItem(packageName) # Probably should be done via a signal
		
		GameCommands.CreateIntelligencePackage.Package_Name = packageName
		GameCommands.CreateIntelligencePackage.Created_By_Country = ControllingCountry.get_name()
		GameCommands.CreateIntelligencePackage.Intel_List = collectedIntel
		GameCommands.CreateIntelligencePackage.WorldController = WorldController
		GameCommands.CreateIntelligencePackage.execute()
	
func OnSendPackage(var packageName, var sendToCountry) -> void:
	GameCommands.ShareIntelligence.Package_Name = packageName
	GameCommands.ShareIntelligence.SendTo_Country = sendToCountry
	GameCommands.ShareIntelligence.SendFrom_Country = ControllingCountry.get_name()
	GameCommands.ShareIntelligence.WorldController = WorldController
	GameCommands.ShareIntelligence.execute()
	
func OnPackageSelected(var packageName):
	var package = ControllingCountry.getIntelligencePackage(packageName)
	
	for child in get_children():
		child.setSelected(false)
		
	for intel in package.IntelligenceForEntities:
		for child in get_children():
			if intel == child.getFocus():
				child.setSelected(true)
				
func OnIntelAdded(screenPos : Vector2, previewTexture : Texture):
	var worldPos = _ScreenToWorld(screenPos)
	
	var sprite : Sprite = Sprite.new()
	sprite.texture = previewTexture.duplicate()
	sprite.position = worldPos
	
	_addIntelWidget(sprite, 4)
	
func _ScreenToWorld(screenPos):
	var tranform = CameraToUse.get_viewport().canvas_transform.affine_inverse()
	var worldPos = tranform * screenPos
	return worldPos
