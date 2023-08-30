extends Node2D

signal ConstructionFinished(structure)

# https://kidscancode.org/godot_recipes/basics/custom_resources/
export (Resource) var StructureInformation
export (Texture) var ConstructionImage
export (Texture) var StructureImage

# Private
enum StructureStateEnum {STRUCTURE_CONSTRUCTING, STRUCTURE_CONSTRUCTION_PAUSED, STRUCTURE_ACTIVE}
var _structureState = StructureStateEnum.STRUCTURE_CONSTRUCTING setget SetStructureState, GetStructureState
var _elapsedContructionTime : float = 0

func _ready():
	if _structureState == StructureStateEnum.STRUCTURE_CONSTRUCTING:	
		$EntityObfuscation.setNoneTexture(ConstructionImage)
		
		setShowInfoUI(false)
	$Selection.setCallback(funcref(self, "setShowInfoUI"))

func _process(delta):
	if _structureState == StructureStateEnum.STRUCTURE_CONSTRUCTING:
		_elapsedContructionTime += delta
		if _elapsedContructionTime >= StructureInformation.ContructionTimeDays:
			_structureState = StructureStateEnum.STRUCTURE_ACTIVE
			$EntityObfuscation.setNoneTexture(StructureImage)
			emit_signal("ConstructionFinished", self)
			
	_processInfoUI()

func _processInfoUI() -> void:
	if StructureInformation.ContructionTimeDays > 0:
		$"%BuildPercentage".text = str("%.0f" % (_elapsedContructionTime/StructureInformation.ContructionTimeDays * 100) + "%")
	
	if _structureState == StructureStateEnum.STRUCTURE_ACTIVE:
		$"%BuildPercentage".visible = false
		$"%PauseConstruction".visible = false
		
func SetStructureState(var state):
	_structureState = state
	
func GetStructureState():
	return _structureState
	
func isStructureConstructing() -> bool:
	return _structureState == StructureStateEnum.STRUCTURE_CONSTRUCTING
	
func getBaseConstructionCost() -> int:
	return StructureInformation.ContructionCost
	
func setShowInfoUI(show: bool) -> void:
	if _structureState == StructureStateEnum.STRUCTURE_CONSTRUCTING:
		$"%BuildPercentage".visible = show
		$"%PauseConstruction".visible = show
		
func getRect() -> Rect2:
	var size = $EntityObfuscation.getSize()
	
	size.x = size.x * scale.x
	size.y = size.y * scale.y
	
	var rect = Rect2(position, size)
	return rect

"***** Callbacks *****"
func onPauseConstructionPressed():
	if _structureState == StructureStateEnum.STRUCTURE_CONSTRUCTION_PAUSED:
		_structureState = StructureStateEnum.STRUCTURE_CONSTRUCTING
	else:
		_structureState = StructureStateEnum.STRUCTURE_CONSTRUCTION_PAUSED
