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
			_addIntelWidget(entity, {}, intelLevel, false)
			
func _addIntelWidget(var entity : Node, data : Dictionary, var _intelLevel : int, selected : bool = false):
	var widgetInstance : Node = intelWidgetScene.instance()
	widgetInstance.setFocus(entity)
	widgetInstance.setData(data)
	widgetInstance.setSelected(selected)		
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
			var  dataForIntel : Dictionary = childWidget.getData()		
			collectedIntel.push_back(dataForIntel)
			
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
		if intel.has("FocusNode"):
			for child in get_children():
				if intel["FocusNode"] == child.getFocus():
					child.setSelected(true)		
		elif intel.has("Type"):
			var worldPos = intel["WorldPos"]
			
			var sprite : Sprite = Sprite.new()
			sprite.texture = load("res://GameActions/ViewIntelPackages/UI/Icons/RadarIcon.png")
			sprite.position = worldPos
			
			_addIntelWidget(sprite, intel, 4, true)
		else:
			push_error('Intel Type Not Supported')
				
func OnIntelAdded(screenPos: Vector2, previewTexture: Texture, data: Dictionary):
	var worldPos = _ScreenToWorld(screenPos)
	
	var sprite : Sprite = Sprite.new()
	sprite.texture = previewTexture.duplicate()
	sprite.position = worldPos
	
	_addIntelWidget(sprite, data, 4)
	
func _ScreenToWorld(screenPos):
	var tranform = CameraToUse.get_viewport().canvas_transform.affine_inverse()
	var worldPos = tranform * screenPos
	return worldPos
